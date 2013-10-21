/* This program is used to calculate moving average values for throughput */


#include<stdio.h>
#include<stdlib.h>

struct node
{
	long num;
	struct node *next;
};


struct node *allocnode(long num)
{
	struct node *new;
	new = (struct node *)malloc(sizeof(struct node));
	new->num=num;
	new->next = NULL;
}

double movavg(struct node *head, int samples)
{
	struct node *temp;
	double sum = 0.0;

	for(temp = head; temp != NULL ; temp = temp->next)
		sum += temp->num;

	
	return (double)sum/samples;
}
	
int main(int argc, char *argv[])
{
	long num;
	int i,which, samples=atoi(argv[1]);
	struct node *head1, *head2, *head3, *head4, *head5, *tail1, *tail2, *tail3, *tail4, *tail5;
	struct node *temp;


	scanf("%ld",&num);
	temp = allocnode(num);
	head1 = tail1 = temp;
	printf("%lf\t",movavg(head1,1));
	
        scanf("%ld",&num);
	temp = allocnode(num);
        head2 = tail2 = temp;
	printf("%lf\t",movavg(head2,1));

	scanf("%ld",&num);
        temp = allocnode(num);
        head3 = tail3 = temp;
	printf("%lf\t",movavg(head3,1));

	scanf("%ld",&num);
        temp = allocnode(num);
        head4 = tail4 = temp;
	printf("%lf\t",movavg(head4,1));
	
	scanf("%ld",&num);
        temp = allocnode(num);
        head5 = tail5 = temp;
	printf("%lf\n",movavg(head5,1));
	

	for(i=2; i <= samples ; i++)
	{
		scanf("%ld",&num);
		temp = allocnode(num);
		tail1->next = temp;
		tail1 = tail1->next;
		printf("%lf\t",movavg(head1,i));

                scanf("%ld",&num);
		temp = allocnode(num);
                tail2->next = temp;
                tail2 = tail2->next;
		printf("%lf\t",movavg(head2,i));

		scanf("%ld",&num);
                temp = allocnode(num);
                tail3->next = temp;
                tail3 = tail3->next;
		printf("%lf\t",movavg(head3,i));

		scanf("%ld",&num);
                temp = allocnode(num);
                tail4->next = temp;
                tail4 = tail4->next;
		printf("%lf\t",movavg(head4,i));

		scanf("%ld",&num);
                temp = allocnode(num);
                tail5->next = temp;
                tail5 = tail5->next;
		printf("%lf\n",movavg(head5,i));
	}
	
	which=1;
	while(scanf("%ld",&num) > 0)
	{	
		switch(which)
		{
			case 1: 
				temp = head1;
				head1=head1->next;
				free(temp);
				tail1->next = allocnode(num);
				tail1=tail1->next;

				printf("%lf\t", movavg(head1, samples));
				which++;
				break;
			case 2: 
				temp = head2;
				head2=head2->next;
				free(temp);
                                tail2->next = allocnode(num);
                                tail2=tail2->next;

                                printf("%lf\t", movavg(head2, samples));
				which++;	
				break;

			case 3:
				temp = head3;
                                head3=head3->next;
                                free(temp);
                                tail3->next = allocnode(num);
                                tail3=tail3->next;

                                printf("%lf\t", movavg(head3, samples));
                                which++;
                                break;
			case 4:
				temp = head4;
                                head4=head4->next;
                                free(temp);
                                tail4->next = allocnode(num);
                                tail4=tail4->next;

                                printf("%lf\t", movavg(head4, samples));
                                which++;
                                break;
			case 5:
				temp = head5;
                                head5=head5->next;
                                free(temp);
                                tail5->next = allocnode(num);
                                tail5=tail5->next;

                                printf("%lf\n", movavg(head5, samples));
                                which = 1;
                                break;
		}
	}
	return 0;	
}
	
