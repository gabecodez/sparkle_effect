// Author: Gabriel Sullivan
// Purpose: This program features an AI generated background with visual effects created using
//          an array of objects moving in 3D space based on various rules.
// AI Image Prompt: "Generate an image of a snowy German Christmas village at night"

// global variables
float MOVE_RATE_MULTIPLIER = 3; // how fast the snowflakes should move
int NUM_OF_FLAKES = 5000;
int WINDOW_WIDTH = 1040; // must be set manually for size()
int WINDOW_HEIGHT = 1040; // must be set manually for size()

// Classname: Snowflake
// Purpose: handles the snowflake object
class Snowflake {
    private float x, y, z, width, height, transparency, time_counter, goal_x, goal_y, goal_z, goal_transparency;

    // Function name: constructor
    // Purpose: creates a new snowflake
    // Input: float width - the width of the snowflake
    //        float height - the height of the snowflake
    //        float x - the inital x value of the snowflake
    //        float y - the inital y value of the snowflake
    // Output: Snowflake: the new snowflake object
    Snowflake(float width, float height, float x, float y) {
        this.x = x;
        this.y = y;
        this.z = 0.0f;
        this.width = width;
        this.height = height;
        this.transparency = random(0, 255);
        this.time_counter = random(0, 400);
        pickNewGoal(); // sets initial goal location for snowflake on screen
    } // end constructor

    // Function name: display()
    // Purpose: renders the snowflake
    // Input: none
    // Output: the snowflake object rendered to the screen
    void display() {
        ellipseMode(CENTER);
        fill(255, 255, 255, transparency);
        stroke(0, 0, 0, 0);
        push();
            translate(x,y,z);
            ellipse(0, 0, width, height);
        pop();
    } // end display

    // Function name: moveRandomly
    // Purpose: moves the snowflake
    // Input: float left_bound -  the left side of the screen
    //        float top_bound -  the top side of the screen
    //        float right_bound -  the right side of the screen
    //        float bottom_bound -  the bottom side of the screen
    // Output: the snowflake object rendered to the screen
    void moveRandomly(float left_bound, float top_bound, float right_bound, float bottom_bound) {
        if(time_counter > 900) { // wait 900 frames, then the snowflake picks a new location to float towards
            pickNewGoal();
            time_counter = 0; // reset the counter
        }

        time_counter++; // increment timer
        
        // handle movement
        // for x
        if(x < goal_x) {
            x += random(0.0f, 1f * MOVE_RATE_MULTIPLIER);
        } else {
            x += random(-1f * MOVE_RATE_MULTIPLIER, 0.0f);
        }

        // for y
        if(y < goal_y) {
            y += random(0.0f, 0.5f * MOVE_RATE_MULTIPLIER);
        } else {
            y += random(-0.5f * MOVE_RATE_MULTIPLIER, 0.0f);
        }

        // for z
        if(z < goal_z) {
            z += random(0.0f, 0.5f * MOVE_RATE_MULTIPLIER);
        } else {
            z += random(-0.5f * MOVE_RATE_MULTIPLIER, 0.0f);
        }

        // if its basically at its goal location, choose a new goal
        if(abs(goal_x - x) <= 1 || abs(goal_y - y) <= 1) {
            pickNewGoal();
            time_counter = 0; // reset timer
        }

        // handle transparency changes
        if(transparency < goal_transparency) {
            transparency += random(0.0f, 0.5f * MOVE_RATE_MULTIPLIER);
        } else {
            transparency += random(-0.5f * MOVE_RATE_MULTIPLIER, 0.0f);
        }

        // Keep within left and right bounds
        x = constrain(x, left_bound, right_bound);

        // if the snowflake goes to the bottom
        // as it floats down faster than sideways
        // then bring it back to the top
        if(y > WINDOW_HEIGHT + 10) {
            y = -10.0f;
        }

        // keep within set z bounds
        z = constrain(z, -100.0f, 100.0f);
        // also limit the transparency
        transparency = constrain(transparency, 50.0f, 250.0f);
    } // end moveRandomly

    // Function name: pickNewGoal
    // Purpose: picks a new goal place for the snowflake to aim for
    // Input: none
    // Output: none
    void pickNewGoal() {
        goal_x = random(x-300, x+300);
        goal_y = random(y-20, y+300);
        goal_z = random(z-100, z+100);
        goal_transparency = random(0, 255);
    }

} // end snowflake class

Snowflake[] snowflakes = new Snowflake[NUM_OF_FLAKES]; // snowflakes array
PImage bg; // the background image

void setup() {
    size(1040, 1040, P3D); // set the window size, width and height has to be set manually for some reason otherwise won't work
    background(255); // create a white background
    bg = loadImage("xmas_market.jpg"); // load our image
    bg.resize(WINDOW_WIDTH, WINDOW_WIDTH); // resize image

    // generate the snowflakes
    float rand_x, rand_y, rand_width;
    for(int i = 0; i < NUM_OF_FLAKES; i++) {
        rand_x = random(0, WINDOW_WIDTH); // choose a random x
        rand_y = random(0, WINDOW_WIDTH); // choose a random y
        rand_width = random(1, 3); // choose a random width
        snowflakes[i] = new Snowflake(rand_width, rand_width, rand_x, rand_y);
    }
}

void draw() {
    background(bg); // redraw the background each frame

    // handle the snowflakes each frame
    for(int i = 0; i < NUM_OF_FLAKES; i++) {
        snowflakes[i].moveRandomly(30.0f, 30.0f, WINDOW_WIDTH, WINDOW_WIDTH); // move the snowflake randomly
        snowflakes[i].display(); // render each flake
    }
}
