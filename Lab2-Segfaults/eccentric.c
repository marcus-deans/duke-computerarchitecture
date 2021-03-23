#include <stdio.h>

/* Only change any of these 4 values */
#define V0 1
#define V1 3
#define V2 0
#define V3 3

int main(void) {
    int a;
    char *s;

    /* This is a print statement. Notice the little 'f' at the end!
     * It might be worthwhile to look up how printf works for your future
     * debugging needs... */
    printf("Duke eccentrics:\n====================\n");

    /* for loop */
    for (a = 0; a < V0; a++)
    {
        printf("Forever ");
    }
    printf("Duke\n");

    /* switch statement */
    switch (V1)
    {
    case 0:
        printf("Blue Devils\n");
    case 1:
        printf("Poetry Fox\n");
        break;
    case 2:
        printf("Ketchup\n");
    case 3:
        printf("Blue Devils\n");
        break;
    case 4:
        printf("Phineas\n");
        break;
    case 5:
        printf("Ferb\n");
    default:
        printf("I don't know!\n");
    }

    /* ternary operator */
    s = (V3 == 3) ? "Let's go" : "Boo";

    /* if statement */
    if (V2) {
        printf("%s BEARS!\n", s);
    } else {
        printf("%s Duke!\n", s);
    }

    return 0;
}