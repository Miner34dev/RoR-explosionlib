#include "explosionlib.as" // import explosionlib


void main()
{
    explosion(game.getPersonPosition()); // create an explosion at RoRbot's position (only works when on foot)
}


void frameStep(float dt)
{
    explosion_frameStep(dt); // update the explosion
}
