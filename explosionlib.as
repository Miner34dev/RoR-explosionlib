// variables used by explosion_frameStep()
bool exploding = false;
array<int> explosion_forceids;
float explosion_time;

// create an explosion
void explosion(vector3 explosion_position=vector3(0, 0, 0), float explosion_power=2500.0f, float max_force=999999.9f, float explosion_duration=0.1) // Power: newton per node at 1 meter distance. Maximum power: maximum newton applied per node. Duration: time (in seconds) before the forces are removed.
{
    array<BeamClass@> actors = game.getAllTrucks(); // get all currently spawned vehicles
    vector3 node_position;
    float node_distance;
    float node_force_uncapped, node_force;
    int forceid;
    game.activateAllVehicles(); // make sure no vehicles are disabled during the explosions


    for (uint currentindex=0; currentindex < actors.length(); currentindex++) // executed once for each vehicle
    {
        BeamClass@ currentactor = actors[currentindex]; // current vehicle

        for (int currentnode=0; currentnode < currentactor.getNodeCount(); currentnode++) // executed once for each node in current vehicle
        {
            node_position = currentactor.getNodePosition(currentnode); // get current node position
            node_distance = sqrt(pow(explosion_position[0]-node_position[0], 2)+pow(explosion_position[1]-node_position[1], 2)+pow(explosion_position[2]-node_position[2], 2)); // calculate euclidean distance between node and explosion center
            node_force_uncapped = explosion_power / sqrt(node_distance);
            node_force = (node_force_uncapped < max_force) ? node_force_uncapped : max_force; // make sure to not apply more force than max_force

            forceid = game.getFreeForceNextId();
            game.pushMessage(
                MSG_SIM_ADD_FREEFORCE_REQUESTED, {
                    {"id", forceid },
                    {"type", FREEFORCETYPE_TOWARDS_COORDS },
                    {"base_actor", currentactor.getInstanceId() },
                    {"base_node", currentnode },
                    {"target_coords", explosion_position },
                    {"force_magnitude", -node_force }
                }
            );

            explosion_forceids.insertLast(forceid);
        }
    }
    exploding = true;
    explosion_time = explosion_duration;
}

// meant to run every frame, call directly from frameStep() or the forces will not be removed after the explosion
void explosion_frameStep(float dt)
{
    if (exploding == true)
    {
        explosion_time -= dt;

        if (explosion_time <= 0.0f)
        {
            for (uint currentindex = 0; currentindex < explosion_forceids.length(); currentindex++) // executed once for each explosion freeforce id
            {
                game.pushMessage(
                    MSG_SIM_REMOVE_FREEFORCE_REQUESTED, {
                        {"id", explosion_forceids[currentindex] }
                    }
                );
            }

            exploding = false;
        }
    }
}
