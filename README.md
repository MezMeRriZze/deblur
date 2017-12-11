run recoverViaFullGaussianKernels to recover images via ADMM

Documentation :
    ADMMForTwoPictures is the core part in this project. This algorithm uses ADMM with conjugate gradient as an iterative method inside each iteration of ADMM. 
    im1 im2 are the two out of focus (or maybe in focus image). we is the smooth weight factor, good choice lies between 0.001 to 0.1. rhoMax is the maximum rho for ADMM. filt1 and filt2 are the so believed filters for im1 and im2 respectively. iter is the maximum number of iterations in ADMM.ADMM can also be terminated when the residual is quite small. cgiter is the number of conjugate gradient iterations, cgthres is the maximum residual to terminal conjugate gradient method. mult is the factor to multiply rho. rhoInit is the value for initial rho. neat is whether to ask for key press to show image.
    For Admm, rho is a tradeoff between individual problem optimization and the linker (augmented lagrange multiplier). When rho is small, you can imagine the correlation between two problems is small. In this case, this means that we do not expect two pictures to look really similar. Vice versa. So we want a small rho at first and gentally increase rho to force two images to coincide with each other so we can benefit from having two pictures in hand. 
    Only the first four arguments are required. 
    You can also specify the maximum residual to terminate ADMM and Conjugate Gradient which is a rather advanced tuning.
