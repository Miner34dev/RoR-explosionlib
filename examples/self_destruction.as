#include "explosionlib.as" // import explosionlib

float explosion_timer = 2.0;
bool exploded = false;


void main()
{
    // only added to allow you to execute this with loadscript
}


void frameStep(float dt)
{
    if (not exploded)
    {
        if (inputs.isKeyDownEffective(KC_F1))
        {
            explosion_timer -= dt;
        }
        else
        {
            explosion_timer = 2.0;
        }

        if (explosion_timer <= 0.0f) // if timer ran out
        {
            explosion(game.getPersonPosition()); // cause an explosion at RoRbot's current position
            exploded = true;
        }
    }

    explosion_frameStep(dt); // update the explosion (if there's any)
}
