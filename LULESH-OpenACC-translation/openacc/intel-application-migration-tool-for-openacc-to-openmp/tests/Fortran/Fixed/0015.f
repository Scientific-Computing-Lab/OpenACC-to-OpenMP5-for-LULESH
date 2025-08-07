      program app
      integer :: N
      integer :: res1, res2
!$acc routine(foo,meaningoflife)
!$acc serial copyout(res1, res2)
        call foo(N,res1)
        res2 = meaningoflife(N)
!$acc end serial
        write (*,*) res1 .eq. res2
      end program

      function meaningoflife(N)
        integer :: N
!$acc routine
        meaningoflife = 42 + N
      end function

      subroutine foo (N, R)
        integer, intent(in) :: N
        integer, intent(out) :: R
!$acc routine
        R = N + R
      end subroutine
