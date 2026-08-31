        .text
main:   li      $a0, 0x40000000
        mtc1    $a0, $f0
        sqrt.s  $f0, $f0
        li      $a0, 0x40490FDB
        mtc1    $a0, $f2
        mul.s   $f0, $f0, $f2
        mfc1    $a0, $f0
        li      $v0, 35
        syscall
