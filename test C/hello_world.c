#include <stdio.h>
#include <system.h>

int main()
{
  volatile short *p = (volatile short *) FFT4POINT_0_BASE;
  	  printf("Hello from Nios II \n");
  *p = 1;
  *(p+1) = 0;
  *(p+2) = 2;
  *(p+3) = 0;
  *(p+4) = 3;
  *(p+5) = 0;
  *(p+6) = 4;
  *(p+7) = 0;
  *(p+8) = 0x01;


//  scanf("%d",&*p);
//  scanf("%d",&*(p+1));
//  scanf("%d",&*(p+2));
//  scanf("%d",&*(p+3));
//  scanf("%d",&*(p+4));
//  scanf("%d",&*(p+5));
//  scanf("%d",&*(p+6));
//  scanf("%d",&*(p+7));

//  	 for (int i = 0; i <= 3; i++)
//  	  {
//	int a=2*i;
//	printf("x[%d]_out_re_reg is: ",i);
//	scanf("%d",&*(p+a));
//	int b=2*i+1;
//	printf("x[%d]_out_im_reg is: ",i);
//	scanf("%d",&*(p+b));
//
//  }
//
//  *(p+8) = 0x01;
  printf ("Start !!!\n");

  while(*(p+17) == 0x00)
  {
	  printf("Processing\n");
  }

  printf("Done !!!\n");
  printf("Result in x0_out_re_reg is: %d\n",*(p+9));
  printf("Result in x0_out_ig_reg is: (%d)i\n",*(p+10));
  printf("Result in x1_out_re_reg is: %d\n",*(p+11));
  printf("Result in x1_out_ig_reg is: (%d)i\n",*(p+12));
  printf("Result in x2_out_re_reg is: %d\n",*(p+13));
  printf("Result in x2_out_ig_reg is: (%d)i\n",*(p+14));
  printf("Result in x3_out_re_reg is: %d\n",*(p+15));
  printf("Result in x3_out_ig_reg is: (%d)i\n",*(p+16));


  return 0;
}
