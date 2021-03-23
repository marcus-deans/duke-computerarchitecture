#include <stddef.h>
#include "ll_cycle.h"
/*
int ll_has_cycle(node *head) {
    /* your code here */
    //struct node* tortoise = (struct node*) malloc(sizeof(struct node));
    /*if(head == NULL){
        return 0;
    }
    struct node *tortoise = head;
    struct node *hare = head;

    while (hare->next && hare){
        /*if(hare == NULL){
            return 0;
        }
        hare = hare->next->next;
        /*if (hare->next == NULL){
            return 0;
        }
        hare = hare->next;
        tortoise = tortoise->next;
        if (tortoise == hare){
            return 1;
        }
    }
    return 0;
    /*hare = hare->next;
    if(hare->next == NULL){
        return 0;
    }
    hare = hare->next;
    tortoise = tortoise->next;
    return 0;
} */

int ll_has_cycle(node *head)
{
    //setting up pointers for each to check
    struct node *hare = head;
    struct node *tortoise = head;

    //while loop will iterate through list while there are sufficient nodes
    while(hare && hare->next)
    {
        //hare skips ahead two nodes
        hare = hare->next;
        hare = hare->next;
        tortoise = tortoise->next; //tortoise moves one node forward
        if(tortoise == hare) //if equivalent then cyclic
        {
            return 1;
        }
    }
    return 0; //otherwise non cyclic
}