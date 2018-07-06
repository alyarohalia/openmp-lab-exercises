! This program will numerically compute the integral of
!
!                   4/(1+x*x) 
!   
! from 0 to 1.  The value of this integral is pi -- which 
! is great since it gives us an easy way to check the answer.

program calc_pi

use omp_lib

implicit none

integer, parameter :: MAX_THREADS = 4

integer*8 :: num_steps = 100000000

real*8 step

integer i, num_threads
real*8 x, pi, raw_sum
real*8 start_time, run_time

step = 1.0D0 / num_steps

do num_threads = 1, MAX_THREADS

    call OMP_SET_NUM_THREADS(num_threads)
    start_time = OMP_GET_WTIME()

    raw_sum = 0.0

    !$omp parallel

        !$omp single
            print '(" num_threads = ", i0)', num_threads
        !$omp end single

        !$omp do private(x) reduction(+:raw_sum)
            do i = 1, num_steps
                x = (i-0.5)*step
                raw_sum = raw_sum + 4.0/(1.0+x*x)
            enddo
        !$omp end do

    !$omp end parallel

    pi = step * raw_sum

    run_time = OMP_GET_WTIME() - start_time
    print '(" pi is ", f12.6, " in ", f12.6, " seconds and ", i0, " threads")', pi, run_time, num_threads

enddo

end program
