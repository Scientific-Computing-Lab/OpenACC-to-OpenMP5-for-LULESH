      program test
      integer, parameter :: N = 10
      integer, parameter :: M = 20
      integer, parameter :: O = 30
      real v1(1:N), v2(-1:N,2:M), v3(0:N,1:M,M:O)

!$acc enter data copyin(v1(:2))

!$acc enter data copyin(v1)

!! !$acc enter data copyin(v2(:4,:5))

!$acc enter data pcopyin(v2)

!$acc enter data copyin(v2(:,:))

!! !$acc enter data copyin(v3(0:N,2:M/2,M+1:O))

!$acc enter data present_or_copyin(v3)

!! !$acc exit data copyout(v3(0:2,1:7,M:8))

!$acc exit data pcopyout(v3)

!! !$acc exit data copyout(v2(-1:1,2:5))

!$acc exit data present_or_copyout(v,v2)

      end program
