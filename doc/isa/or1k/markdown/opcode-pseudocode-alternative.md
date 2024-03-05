## Instruction Pseudo Code (Alternative)

Format of a line in the table:

`<instruction name> "<instruction pseudo code>"`

| instruction name       | instruction pseudo code                                                                 |
|------------------------|:----------------------------------------------------------------------------------------|
| `l.add rD,rA,rB`       | `rD[31:0] <- rA[31:0] + rB[31:0]`                                                       |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.addc rD,rA,rB`      | `rD[31:0] <- rA[31:0] + rB[31:0] + SR[CY]`                                              |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.addi rD,rA,I`       | `rD[31:0] <- rA[31:0] + exts(Immediate)`                                                |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.addic rD,rA,I`      | `rD[31:0] <- rA[31:0] + exts(Immediate) + SR[CY]`                                       |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.and rD,rA,rB`       | `rD[31:0] <- rA[31:0] AND rB[31:0]`                                                     |
| `l.andi rD,rA,K`       | `rD[31:0] <- rA[31:0] AND extz(Immediate)`                                              |
| `l.bf N`               | `EA <- exts(Immediate << 2) + BranchInsnAddr`                                           |
|                        | `PC <- EA if SR[F] set`                                                                 |
| `l.bnf N`              | `EA <- exts(Immediate << 2) + BranchInsnAddr`                                           |
|                        | `PC <- EA if SR[F] cleared`                                                             |
| `l.cmov rD,rA,rB`      | `rD[31:0] <- SR[F] ? rA[31:0] : rB[31:0]`                                               |
| `l.csync `             | `context-synchronization`                                                            |
| `l.cust1 `             | `N/A`                                                                                   |
| `l.cust2 `             | `N/A`                                                                                   |
| `l.cust3 `             | `N/A`                                                                                   |
| `l.cust4 `             | `N/A`                                                                                   |
| `l.cust5 rD,rA,rB,L,K` | `N/A`                                                                                   |
| `l.cust6 `             | `N/A`                                                                                   |
| `l.cust7 `             | `N/A`                                                                                   |
| `l.cust8 `             | `N/A`                                                                                   |
| `l.div rD,rA,rB`       | `rD[31:0] <- rA[31:0] / rB[31:0]`                                                       |
|                        | `SR[OV] <- rB[31:0] == 0`                                                               |
| `l.divu rD,rA,rB`      | `rD[31:0] <- rA[31:0] / rB[31:0]`                                                       |
|                        | `SR[CY] <- rB[31:0] == 0`                                                               |
| `l.extbs rD,rA`        | `rD[31:8] <- rA[7]`                                                                     |
|                        | `rD[7:0] <- rA[7:0]`                                                                    |
| `l.extbz rD,rA`        | `rD[31:8] <- 0`                                                                         |
|                        | `rD[7:0] <- rA[7:0]`                                                                    |
| `l.exths rD,rA`        | `rD[31:16] <- rA[15]`                                                                   |
|                        | `rD[15:0] <- rA[15:0]`                                                                  |
| `l.exthz rD,rA`        | `rD[31:16] <- 0`                                                                        |
|                        | `rD[15:0] <- rA[15:0]`                                                                  |
| `l.extws rD,rA`        | `rD[31:0] <- rA[31:0]`                                                                  |
| `l.extwz rD,rA`        | `rD[31:0] <- rA[31:0]`                                                                  |
| `l.ff1 rD,rA,rB`       | `rD[31:0] <- rA[0] ? 1 : rA[1] ? 2 ... rA[31] ? 32 : 0`                                 |
| `l.fl1 rD,rA,rB`       | `rD[31:0] <- rA[31] ? 32 : rA[30] ? 31 ... rA[0] ? 1 : 0`                               |
| `l.j N`                | `PC <- exts(Immediate << 2) + JumpInsnAddr`                                             |
| `l.jal N`              | `PC <- exts(Immediate << 2) + JumpInsnAddr`                                             |
|                        | `LR <- CPUCFGR[ND] ? JumpInsnAddr + 4 : DelayInsnAddr + 4`                              |
| `l.jalr rB`            | `PC <- rB`                                                                              |
|                        | `LR <- CPUCFGR[ND] ? JumpInsnAddr + 4 : DelayInsnAddr + 4.`                             |
| `l.jr rB`              | `PC <- rB`                                                                              |
| `l.lbs rD,I(rA)`       | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `rD[7:0] <- (EA)[7:0]`                                                                  |
|                        | `rD[31:8] <- (EA)[7]`                                                                   |
| `l.lbz rD,I(rA)`       | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `rD[7:0] <- (EA)[7:0]`                                                                  |
|                        | `rD[31:8] <- 0`                                                                         |
| `l.ld rD,I(rA)`        | `N/A`                                                                                   |
| `l.lhs rD,I(rA)`       | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `rD[15:0] <- (EA)[15:0]`                                                                |
|                        | `rD[31:16] <- (EA)[15]`                                                                 |
| `l.lhz rD,I(rA)`       | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `rD[15:0] <- (EA)[15:0]`                                                                |
|                        | `rD[31:16] <- 0`                                                                        |
| `l.lwa rD,I(rA)`       | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `rD[31:0] <- (EA)[31:0]`                                                                |
|                        | `atomic_reserve[to_phys(EA)] <- 1`                                                      |
| `l.lws rD,I(rA)`       | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `rD[31:0] <- (EA)[31:0]`                                                                |
| `l.lwz rD,I(rA)`       | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `rD[31:0] <- (EA)[31:0]`                                                                |
| `l.mac rA,rB`          | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] + rA[31:0] * rB[31:0]`                |
|                        | `SR[OV] <- signed overflow during addition stage`                                       |
| `l.maci rA,I`          | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] + rA[31:0] * exts(Immediate)`         |
|                        | `SR[OV] <- signed overflow during addition stage`                                       |
| `l.macrc rD`           | `synchronize-mac`                                                                       |
|                        | `rD[31:0] <- MACLO[31:0]`                                                               |
|                        | `MACLO[31:0], MACHI[31:0] <- 0`                                                         |
| `l.macu rA,rB`         | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] + rA[31:0] * rB[31:0]`                |
|                        | `SR[CY] <- unsigned overflow during addition stage`                                     |
| `l.mfspr rD,rA,K`      | `rD[31:0] <- spr(rA OR Immediate)`                                                      |
| `l.movhi rD,K`         | `rD[31:0] <- extz(Immediate) << 16`                                                     |
| `l.msb rA,rB`          | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] - rA[31:0] * rB[31:0]`                |
|                        | `SR[OV] <- signed overflow during subtraction stage`                                    |
| `l.msbu rA,rB`         | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] - rA[31:0] * rB[31:0]`                |
|                        | `SR[CY] <- unsigned overflow during subtraction stage`                                  |
| `l.msync `             | `Memory-synchronization`                                                                |
| `l.mtspr rA,rB,K`      | `spr(rA OR Immediate) <- rB[31:0]`                                                      |
| `l.mul rD,rA,rB`       | `rD[31:0] <- rA[31:0] * rB[31:0]`                                                       |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.muld rA,rB`         | `MACHI[31:0]MACLO[31:0] <- rA[31:0] * rB[31:0]`                                         |
| `l.muldu rA,rB`        | `MACHI[31:0]MACLO[31:0] <- rA[31:0] * rB[31:0]`                                         |
| `l.muli rD,rA,I`       | `rD[31:0] <- rA[31:0] * exts(Immediate)`                                                |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.mulu rD,rA,rB`      | `rD[31:0] <- rA[31:0] * rB[31:0]`                                                       |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
| `l.nop K`              | `N/A`                                                                                   |
| `l.or rD,rA,rB`        | `rD[31:0] <- rA[31:0] OR rB[31:0]`                                                      |
| `l.ori rD,rA,K`        | `rD[31:0] <- rA[31:0] OR extz(Immediate)`                                               |
| `l.psync `             | `pipeline-synchronization`                                                           |
| `l.rfe `               | `PC <- EPCR`                                                                            |
|                        | `SR <- ESR`                                                                             |
| `l.ror rD,rA,rB`       | `rD[31-rB[4:0]:0] <- rA[31:rB[4:0]]`                                                    |
|                        | `rD[31:32-rB[4:0]] <- rA[rB[4:0]-1:0]`                                                  |
| `l.rori rD,rA,L`       | `rD[31-L:0] <- rA[31:L]`                                                                |
|                        | `rD[31:32-L] <- rA[L-1:0]`                                                              |
| `l.sb I(rA),rB`        | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `(EA)[7:0] <- rB[7:0]`                                                                  |
| `l.sd I(rA),rB`        | `N/A`                                                                                   |
| `l.sfeq rA,rB`         | `SR[F] <- rA[31:0] == rB[31:0]`                                                         |
| `l.sfeqi rA,I`         | `SR[F] <- rA[31:0] == exts(Immediate)`                                                  |
| `l.sfges rA,rB`        | `SR[F] <- rA[31:0] >= rB[31:0]`                                                         |
| `l.sfgesi rA,I`        | `SR[F] <- rA[31:0] >= exts(Immediate)`                                                  |
| `l.sfgeu rA,rB`        | `SR[F] <- rA[31:0] >= rB[31:0]`                                                         |
| `l.sfgeui rA,I`        | `SR[F] <- rA[31:0] >= exts(Immediate)`                                                  |
| `l.sfgts rA,rB`        | `SR[F] <- rA[31:0] > rB[31:0]`                                                          |
| `l.sfgtsi rA,I`        | `SR[F] <- rA[31:0] > exts(Immediate)`                                                   |
| `l.sfgtu rA,rB`        | `SR[F] <- rA[31:0] > rB[31:0]`                                                          |
| `l.sfgtui rA,I`        | `SR[F] <- rA[31:0] > exts(Immediate)`                                                   |
| `l.sfles rA,rB`        | `SR[F] <- rA[31:0] <= rB[31:0]`                                                         |
| `l.sflesi rA,I`        | `SR[F] <- rA[31:0] <= exts(Immediate)`                                                  |
| `l.sfleu rA,rB`        | `SR[F] <- rA[31:0] <= rB[31:0]`                                                         |
| `l.sfleui rA,I`        | `SR[F] <- rA[31:0] <= exts(Immediate)`                                                  |
| `l.sflts rA,rB`        | `SR[F] <- rA[31:0] < rB[31:0]`                                                          |
| `l.sfltsi rA,I`        | `SR[F] <- rA[31:0] < exts(Immediate)`                                                   |
| `l.sfltu rA,rB`        | `SR[F] <- rA[31:0] < rB[31:0]`                                                          |
| `l.sfltui rA,I`        | `SR[F] <- rA[31:0] < exts(Immediate)`                                                   |
| `l.sfne rA,rB`         | `SR[F] <- rA[31:0] != rB[31:0]`                                                         |
| `l.sfnei rA,I`         | `SR[F] <- rA[31:0] != exts(Immediate)`                                                  |
| `l.sh I(rA),rB`        | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `(EA)[15:0] <- rB[15:0]`                                                                |
| `l.sll rD,rA,rB`       | `rD[31:rB[4:0]] <- rA[31-rB[4:0]:0]`                                                    |
|                        | `rD[rB[4:0]-1:0] <- 0`                                                                  |
| `l.slli rD,rA,L`       | `rD[31:L] <- rA[31-L:0]`                                                                |
|                        | `rD[L-1:0] <- 0`                                                                        |
| `l.sra rD,rA,rB`       | `rD[31-rB[4:0]:0] <- rA[31:rB[4:0]]`                                                    |
|                        | `rD[31:32-rB[4:0]] <- rA[31]`                                                           |
| `l.srai rD,rA,L`       | `rD[31-L:0] <- rA[31:L]`                                                                |
|                        | `rD[31:32-L] <- rA[31]`                                                                 |
| `l.srl rD,rA,rB`       | `rD[31-rB[4:0]:0] <- rA[31:rB[4:0]]`                                                    |
|                        | `rD[31:32-rB[4:0]] <- 0`                                                                |
| `l.srli rD,rA,L`       | `rD[31-L:0] <- rA[31:L]`                                                                |
|                        | `rD[31:32-L] <- 0`                                                                      |
| `l.sub rD,rA,rB`       | `rD[31:0] <- rA[31:0] - rB[31:0]`                                                       |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.sw I(rA),rB`        | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `(EA)[31:0] <- rB[31:0]`                                                                |
| `l.swa I(rA),rB`       | `EA <- exts(Immediate) + rA[31:0]`                                                      |
|                        | `if (atomic) (EA)[31:0] <- rB[31:0]`                                                    |
|                        | `SR[F] <- atomic`                                                                       |
| `l.sys K`              | `system-call-exception(K)`                                                              |
| `l.trap K`             | `trap-exception()`                                                                      |
| `l.xor rD,rA,rB`       | `rD[31:0] <- rA[31:0] XOR rB[31:0]`                                                     |
| `l.xori rD,rA,I`       | `rD[31:0] <- rA[31:0] XOR exts(Immediate)`                                              |
| `lf.add.d rD,rA,rB`    | `N/A`                                                                                   |
| `lf.add.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] + rB[31:0]`                                                       |
| `lf.cust1.d rA,rB`     | `N/A`                                                                                   |
| `lf.cust1.s rA,rB`     | `N/A`                                                                                   |
| `lf.div.d rD,rA,rB`    | `N/A`                                                                                   |
| `lf.div.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] / rB[31:0]`                                                       |
| `lf.ftoi.d rD,rA`      | `N/A`                                                                                   |
| `lf.ftoi.s rD,rA`      | `rD[31:0] <- ftoi(rA[31:0])`                                                            |
| `lf.itof.d rD,rA`      | `N/A`                                                                                   |
| `lf.itof.s rD,rA`      | `rD[31:0] <- itof(rA[31:0])`                                                            |
| `lf.madd.d rD,rA,rB`   | `N/A`                                                                                   |
| `lf.madd.s rD,rA,rB`   | `FPMADDHI[31:0]FPMADDLO[31:0] <- rA[31:0] * rB[31:0] + FPMADDHI[31:0]FPMADDLO[31:0]` |
| `lf.mul.d rD,rA,rB`    | `N/A`                                                                                   |
| `lf.mul.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] * rB[31:0]`                                                       |
| `lf.rem.d rD,rA,rB`    | `N/A`                                                                                   |
| `lf.rem.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] % rB[31:0]`                                                       |
| `lf.sfeq.d rA,rB`      | `N/A`                                                                                   |
| `lf.sfeq.s rA,rB`      | `SR[F] <- rA[31:0] == rB[31:0]`                                                         |
| `lf.sfge.d rA,rB`      | `N/A`                                                                                   |
| `lf.sfge.s rA,rB`      | `SR[F] <- rA[31:0] >= rB[31:0]`                                                         |
| `lf.sfgt.d rA,rB`      | `N/A`                                                                                   |
| `lf.sfgt.s rA,rB`      | `SR[F] <- rA[31:0] > rB[31:0]`                                                          |
| `lf.sfle.d rA,rB`      | `N/A`                                                                                   |
| `lf.sfle.s rA,rB`      | `SR[F] <- rA[31:0] <= rB[31:0]`                                                         |
| `lf.sflt.d rA,rB`      | `N/A`                                                                                   |
| `lf.sflt.s rA,rB`      | `SR[F] <- rA[31:0] < rB[31:0]`                                                          |
| `lf.sfne.d rA,rB`      | `N/A`                                                                                   |
| `lf.sfne.s rA,rB`      | `SR[F] <- rA[31:0] != rB[31:0]`                                                         |
| `lf.sub.d rD,rA,rB`    | `N/A`                                                                                   |
| `lf.sub.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] - rB[31:0]`                                                       |
| `lv.add.b rD,rA,rB`    | `N/A`                                                                                   |
| `lv.add.h rD,rA,rB`    | `N/A`                                                                                   |
| `lv.adds.b rD,rA,rB`   | `N/A`                                                                                   |
| `lv.adds.h rD,rA,rB`   | `N/A`                                                                                   |
| `lv.addu.b rD,rA,rB`   | `N/A`                                                                                   |
| `lv.addu.h rD,rA,rB`   | `N/A`                                                                                   |
| `lv.addus.b rD,rA,rB`  | `N/A`                                                                                   |
| `lv.addus.h rD,rA,rB`  | `N/A`                                                                                   |
| `lv.all_eq.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_eq.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_ge.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_ge.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_gt.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_gt.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_le.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_le.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_lt.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_lt.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_ne.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.all_ne.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.and rD,rA,rB`      | `N/A`                                                                                   |
| `lv.any_eq.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_eq.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_ge.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_ge.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_gt.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_gt.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_le.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_le.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_lt.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_lt.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_ne.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.any_ne.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.avg.b rD,rA,rB`    | `N/A`                                                                                   |
| `lv.avg.h rD,rA,rB`    | `N/A`                                                                                   |
| `lv.cmp_eq.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_eq.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_ge.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_ge.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_gt.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_gt.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_le.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_le.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_lt.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_lt.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_ne.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.cmp_ne.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.cust1 `            | `N/A`                                                                                   |
| `lv.cust2 `            | `N/A`                                                                                   |
| `lv.cust3 `            | `N/A`                                                                                   |
| `lv.cust4 `            | `N/A`                                                                                   |
| `lv.madds.h rD,rA,rB`  | `N/A`                                                                                   |
| `lv.max.b rD,rA,rB`    | `N/A`                                                                                   |
| `lv.max.h rD,rA,rB`    | `N/A`                                                                                   |
| `lv.merge.b rD,rA,rB`  | `N/A`                                                                                   |
| `lv.merge.h rD,rA,rB`  | `N/A`                                                                                   |
| `lv.min.b rD,rA,rB`    | `N/A`                                                                                   |
| `lv.min.h rD,rA,rB`    | `N/A`                                                                                   |
| `lv.msubs.h rD,rA,rB`  | `N/A`                                                                                   |
| `lv.muls.h rD,rA,rB`   | `N/A`                                                                                   |
| `lv.nand rD,rA,rB`     | `N/A`                                                                                   |
| `lv.nor rD,rA,rB`      | `N/A`                                                                                   |
| `lv.or rD,rA,rB`       | `N/A`                                                                                   |
| `lv.pack.b rD,rA,rB`   |                                                                                         |
| `lv.pack.h rD,rA,rB`   | `N/A`                                                                                   |
| `lv.packs.b rD,rA,rB`  |                                                                                         |
| `lv.packs.h rD,rA,rB`  | `N/A`                                                                                   |
| `lv.packus.b rD,rA,rB` |                                                                                         |
| `lv.packus.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.perm.n rD,rA,rB`   |                                                                                         |
| `lv.rl.b rD,rA,rB`     | `N/A`                                                                                   |
| `lv.rl.h rD,rA,rB`     | `N/A`                                                                                   |
| `lv.sll rD,rA,rB`      | `N/A`                                                                                   |
| `lv.sll.b rD,rA,rB`    | `N/A`                                                                                   |
| `lv.sll.h rD,rA,rB`    | `N/A`                                                                                   |
| `lv.sra.b rD,rA,rB`    | `N/A`                                                                                   |
| `lv.sra.h rD,rA,rB`    | `N/A`                                                                                   |
| `lv.srl rD,rA,rB`      | `N/A`                                                                                   |
| `lv.srl.b rD,rA,rB`    | `N/A`                                                                                   |
| `lv.srl.h rD,rA,rB`    | `N/A`                                                                                   |
| `lv.sub.b rD,rA,rB`    | `N/A`                                                                                   |
| `lv.sub.h rD,rA,rB`    | `N/A`                                                                                   |
| `lv.subs.b rD,rA,rB`   | `N/A`                                                                                   |
| `lv.subs.h rD,rA,rB`   | `N/A`                                                                                   |
| `lv.subu.b rD,rA,rB`   | `N/A`                                                                                   |
| `lv.subu.h rD,rA,rB`   | `N/A`                                                                                   |
| `lv.subus.b rD,rA,rB`  | `N/A`                                                                                   |
| `lv.subus.h rD,rA,rB`  | `N/A`                                                                                   |
| `lv.unpack.b rD,rA,rB` | `N/A`                                                                                   |
| `lv.unpack.h rD,rA,rB` | `N/A`                                                                                   |
| `lv.xor rD,rA,rB`      | `N/A`                                                                                   |
: OpenRISC 32-Bit - "OpenRISC 32-Bit Base Integer Instruction Set"


| instruction name       | instruction pseudo code                                                                 |
|------------------------|:----------------------------------------------------------------------------------------|
| `l.add rD,rA,rB`       | `rD[63:0] <- rA[63:0] + rB[63:0]`                                                       |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.addc rD,rA,rB`      | `rD[63:0] <- rA[63:0] + rB[63:0] + SR[CY]`                                              |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- overflow`                                                                    |
| `l.addi rD,rA,I`       | `rD[63:0] <- rA[63:0] + exts(Immediate)`                                                |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.addic rD,rA,I`      | `rD[63:0] <- rA[63:0] + exts(Immediate) + SR[CY]`                                       |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.and rD,rA,rB`       | `rD[63:0] <- rA[63:0] AND rB[63:0]`                                                     |
| `l.andi rD,rA,K`       | `rD[63:0] <- rA[63:0] AND extz(Immediate)`                                              |
| `l.bf N`               | `EA <- exts(Immediate << 2) + BranchInsnAddr`                                           |
|                        | `PC <- EA if SR[F] set`                                                                 |
| `l.bnf N`              | `EA <- exts(Immediate << 2) + BranchInsnAddr`                                           |
|                        | `PC <- EA if SR[F] cleared`                                                             |
| `l.cmov rD,rA,rB`      | `rD[63:0] <- SR[F] ? rA[63:0] : rB[63:0]`                                               |
| `l.csync `             | `context-synchronization`                                                            |
| `l.cust1 `             | `N/A`                                                                                   |
| `l.cust2 `             | `N/A`                                                                                   |
| `l.cust3 `             | `N/A`                                                                                   |
| `l.cust4 `             | `N/A`                                                                                   |
| `l.cust5 rD,rA,rB,L,K` | `N/A`                                                                                   |
| `l.cust6 `             | `N/A`                                                                                   |
| `l.cust7 `             | `N/A`                                                                                   |
| `l.cust8 `             | `N/A`                                                                                   |
| `l.div rD,rA,rB`       | `rD[63:0] <- rA[63:0] / rB[63:0]`                                                       |
|                        | `SR[OV] <- rB[63:0] == 0`                                                               |
| `l.divu rD,rA,rB`      | `rD[63:0] <- rA[63:0] / rB[63:0]`                                                       |
|                        | `SR[CY] <- rB[63:0] == 0`                                                               |
| `l.extbs rD,rA`        | `rD[63:8] <- rA[7]`                                                                     |
|                        | `rD[7:0] <- rA[7:0]`                                                                    |
| `l.extbz rD,rA`        | `rD[63:8] <- 0`                                                                         |
|                        | `rD[7:0] <- rA[7:0]`                                                                    |
| `l.exths rD,rA`        | `rD[63:16] <- rA[15]`                                                                   |
|                        | `rD[15:0] <- rA[15:0]`                                                                  |
| `l.exthz rD,rA`        | `rD[63:16] <- 0`                                                                        |
|                        | `rD[15:0] <- rA[15:0]`                                                                  |
| `l.extws rD,rA`        | `rD[63:32] <- rA[31]`                                                                   |
|                        | `rD[31:0] <- rA[31:0]`                                                                  |
| `l.extwz rD,rA`        | `rD[63:32] <- 0`                                                                        |
|                        | `rD[31:0] <- rA[31:0]`                                                                  |
| `l.ff1 rD,rA,rB`       | `rD[63:0] <- rA[0] ? 1 : rA[1] ? 2 ... rA[63] ? 64 : 0`                                 |
| `l.fl1 rD,rA,rB`       | `rD[63:0] <- rA[63] ? 64 : rA[62] ? 63 ... rA[0] ? 1 : 0`                               |
| `l.j N`                | `PC <- exts(Immediate << 2) + JumpInsnAddr`                                             |
| `l.jal N`              | `PC <- exts(Immediate << 2) + JumpInsnAddr`                                             |
|                        | `LR <- CPUCFGR[ND] ? JumpInsnAddr + 4 : DelayInsnAddr + 4`                              |
| `l.jalr rB`            | `PC <- rB`                                                                              |
|                        | `LR <- CPUCFGR[ND] ? JumpInsnAddr + 4 : DelayInsnAddr + 4.`                             |
| `l.jr rB`              | `PC <- rB`                                                                              |
| `l.lbs rD,I(rA)`       | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `rD[7:0] <- (EA)[7:0]`                                                                  |
|                        | `rD[63:8] <- (EA)[7]`                                                                   |
| `l.lbz rD,I(rA)`       | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `rD[7:0] <- (EA)[7:0]`                                                                  |
|                        | `rD[63:8] <- 0`                                                                         |
| `l.ld rD,I(rA)`        | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `rD[63:0] <- (EA)[63:0]`                                                                |
| `l.lhs rD,I(rA)`       | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `rD[15:0] <- (EA)[15:0]`                                                                |
|                        | `rD[63:16] <- (EA)[15]`                                                                 |
| `l.lhz rD,I(rA)`       | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `rD[15:0] <- (EA)[15:0]`                                                                |
|                        | `rD[63:16] <- 0`                                                                        |
| `l.lwa rD,I(rA)`       | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `rD[31:0] <- (EA)[31:0]`                                                                |
|                        | `rD[63:32] <- 0`                                                                        |
|                        | `atomic_reserve[to_phys(EA)] <- 1`                                                      |
| `l.lws rD,I(rA)`       | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `rD[31:0] <- (EA)[31:0]`                                                                |
|                        | `rD[63:32] <- (EA)[31]`                                                                 |
| `l.lwz rD,I(rA)`       | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `rD[31:0] <- (EA)[31:0]`                                                                |
|                        | `rD[63:32] <- 0`                                                                        |
| `l.mac rA,rB`          | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] + rA[63:0] * rB[63:0]`                |
|                        | `SR[OV] <- signed overflow during addition stage`                                       |
| `l.maci rA,I`          | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] + rA[63:0] * exts(Immediate)`         |
|                        | `SR[OV] <- signed overflow during addition stage`                                       |
| `l.macrc rD`           | `synchronize-mac`                                                                       |
|                        | `rD[63:0] <- MACHI[31:0]MACLO[31:0]`                                                    |
|                        | `MACLO[31:0], MACHI[31:0] <- 0`                                                         |
| `l.macu rA,rB`         | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] + rA[63:0] * rB[63:0]`                |
|                        | `SR[CY] <- unsigned overflow during addition stage`                                     |
| `l.mfspr rD,rA,K`      | `rD[63:0] <- spr(rA OR Immediate)`                                                      |
| `l.movhi rD,K`         | `rD[63:0] <- extz(Immediate) << 16`                                                     |
| `l.msb rA,rB`          | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] - rA[63:0] * rB[63:0]`                |
|                        | `SR[OV] <- signed overflow during subtraction stage`                                    |
| `l.msbu rA,rB`         | `MACHI[31:0]MACLO[31:0] <- MACHI[31:0]MACLO[31:0] - rA[63:0] * rB[63:0]`                |
|                        | `SR[CY] <- unsigned overflow during subtraction stage`                                  |
| `l.msync `             | `Memory-synchronization`                                                                |
| `l.mtspr rA,rB,K`      | `spr(rA OR Immediate) <- rB[31:0]`                                                      |
| `l.mul rD,rA,rB`       | `rD[63:0] <- rA[63:0] * rB[63:0]`                                                       |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.muld rA,rB`         | `MACHI[31:0]MACLO[31:0] <- rA[63:0] * rB[63:0]`                                         |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.muldu rA,rB`        | `MACHI[31:0]MACLO[31:0] <- rA[63:0] * rB[63:0]`                                         |
|                        | `SR[CY] <- unsigned overflow`                                                           |
| `l.muli rD,rA,I`       | `rD[63:0] <- rA[63:0] * exts(Immediate)`                                                |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.mulu rD,rA,rB`      | `rD[63:0] <- rA[63:0] * rB[63:0]`                                                       |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
| `l.nop K`              | `N/A`                                                                                   |
| `l.or rD,rA,rB`        | `rD[63:0] <- rA[63:0] OR rB[63:0]`                                                      |
| `l.ori rD,rA,K`        | `rD[63:0] <- rA[63:0] OR extz(Immediate)`                                               |
| `l.psync `             | `pipeline-synchronization`                                                           |
| `l.rfe `               | `PC <- EPCR`                                                                            |
|                        | `SR <- ESR`                                                                             |
| `l.ror rD,rA,rB`       | `rD[63-rB[5:0]:0] <- rA[63:rB[5:0]]`                                                    |
|                        | `rD[63:64-rB[5:0]] <- rA[rB[5:0]-1:0]`                                                  |
| `l.rori rD,rA,L`       | `rD[63-L:0] <- rA[63:L]`                                                                |
|                        | `rD[63:64-L] <- rA[L-1:0]`                                                              |
| `l.sb I(rA),rB`        | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `(EA)[7:0] <- rB[7:0]`                                                                  |
| `l.sd I(rA),rB`        | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `(EA)[63:0] <- rB[63:0]`                                                                |
| `l.sfeq rA,rB`         | `SR[F] <- rA[63:0] == rB[63:0]`                                                         |
| `l.sfeqi rA,I`         | `SR[F] <- rA[63:0] == exts(Immediate)`                                                  |
| `l.sfges rA,rB`        | `SR[F] <- rA[63:0] >= rB[63:0]`                                                         |
| `l.sfgesi rA,I`        | `SR[F] <- rA[63:0] >= exts(Immediate)`                                                  |
| `l.sfgeu rA,rB`        | `SR[F] <- rA[63:0] >= rB[63:0]`                                                         |
| `l.sfgeui rA,I`        | `SR[F] <- rA[63:0] >= exts(Immediate)`                                                  |
| `l.sfgts rA,rB`        | `SR[F] <- rA[63:0] > rB[63:0]`                                                          |
| `l.sfgtsi rA,I`        | `SR[F] <- rA[63:0] > exts(Immediate)`                                                   |
| `l.sfgtu rA,rB`        | `SR[F] <- rA[63:0] > rB[63:0]`                                                          |
| `l.sfgtui rA,I`        | `SR[F] <- rA[63:0] > exts(Immediate)`                                                   |
| `l.sfles rA,rB`        | `SR[F] <- rA[63:0] <= rB[63:0]`                                                         |
| `l.sflesi rA,I`        | `SR[F] <- rA[63:0] <= exts(Immediate)`                                                  |
| `l.sfleu rA,rB`        | `SR[F] <- rA[63:0] <= rB[63:0]`                                                         |
| `l.sfleui rA,I`        | `SR[F] <- rA[63:0] <= exts(Immediate)`                                                  |
| `l.sflts rA,rB`        | `SR[F] <- rA[63:0] < rB[63:0]`                                                          |
| `l.sfltsi rA,I`        | `SR[F] <- rA[63:0] < exts(Immediate)`                                                   |
| `l.sfltu rA,rB`        | `SR[F] <- rA[63:0] < rB[63:0]`                                                          |
| `l.sfltui rA,I`        | `SR[F] <- rA[63:0] < exts(Immediate)`                                                   |
| `l.sfne rA,rB`         | `SR[F] <- rA[63:0] != rB[63:0]`                                                         |
| `l.sfnei rA,I`         | `SR[F] <- rA[63:0] != exts(Immediate)`                                                  |
| `l.sh I(rA),rB`        | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `(EA)[15:0] <- rB[15:0]`                                                                |
| `l.sll rD,rA,rB`       | `rD[63:rB[5:0]] <- rA[63-rB[5:0]:0]`                                                    |
|                        | `rD[rB[5:0]-1:0] <- 0`                                                                  |
| `l.slli rD,rA,L`       | `rD[63:L] <- rA[63-L:0]`                                                                |
|                        | `rD[L-1:0] <- 0`                                                                        |
| `l.sra rD,rA,rB`       | `rD[63-rB[5:0]:0] <- rA[63:rB[5:0]]`                                                    |
|                        | `rD[63:64-rB[5:0]] <- rA[63]`                                                           |
| `l.srai rD,rA,L`       | `rD[63-L:0] <- rA[63:L]`                                                                |
|                        | `rD[63:64-L] <- rA[63]`                                                                 |
| `l.srl rD,rA,rB`       | `rD[63-rB[5:0]:0] <- rA[63:rB[5:0]]`                                                    |
|                        | `rD[63:64-rB[5:0]] <- 0`                                                                |
| `l.srli rD,rA,L`       | `rD[63-L:0] <- rA[63:L]`                                                                |
|                        | `rD[63:64-L] <- 0`                                                                      |
| `l.sub rD,rA,rB`       | `rD[63:0] <- rA[63:0] - rB[63:0]`                                                       |
|                        | `SR[CY] <- carry (unsigned overflow)`                                                   |
|                        | `SR[OV] <- signed overflow`                                                             |
| `l.sw I(rA),rB`        | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `(EA)[31:0] <- rB[31:0]`                                                                |
| `l.swa I(rA),rB`       | `EA <- exts(Immediate) + rA[63:0]`                                                      |
|                        | `if (atomic) (EA)[31:0] <- rB[31:0]`                                                    |
|                        | `SR[F] <- atomic`                                                                       |
| `l.sys K`              | `system-call-exception(K)`                                                              |
| `l.trap K`             | `trap-exception()`                                                                      |
| `l.xor rD,rA,rB`       | `rD[63:0] <- rA[63:0] XOR rB[63:0]`                                                     |
| `l.xori rD,rA,I`       | `rD[63:0] <- rA[63:0] XOR exts(Immediate)`                                              |
| `lf.add.d rD,rA,rB`    | `rD[63:0] <- rA[63:0] + rB[63:0]`                                                       |
| `lf.add.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] + rB[31:0]`                                                       |
|                        | `rD[63:32] <- 0`                                                                        |
| `lf.cust1.d rA,rB`     | `N/A`                                                                                   |
| `lf.cust1.s rA,rB`     | `N/A`                                                                                   |
| `lf.div.d rD,rA,rB`    | `rD[63:0] <- rA[63:0] / rB[63:0]`                                                       |
| `lf.div.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] / rB[31:0]`                                                       |
|                        | `rD[63:32] <- 0`                                                                        |
| `lf.ftoi.d rD,rA`      | `rD[63:0] <- ftoi(rA[63:0])`                                                            |
| `lf.ftoi.s rD,rA`      | `rD[31:0] <- ftoi(rA[31:0])`                                                            |
|                        | `rD[63:32] <- 0`                                                                        |
| `lf.itof.d rD,rA`      | `rD[63:0] <- itof(rA[63:0])`                                                            |
| `lf.itof.s rD,rA`      | `rD[31:0] <- itof(rA[31:0])`                                                            |
|                        | `rD[63:32] <- 0`                                                                        |
| `lf.madd.d rD,rA,rB`   | `FPMADDHI[31:0]FPMADDLO[31:0] <- rA[63:0] * rB[63:0] + FPMADDHI[31:0]FPMADDLO[31:0]` |
| `lf.madd.s rD,rA,rB`   | `FPMADDHI[31:0]FPMADDLO[31:0] <- rA[31:0] * rB[31:0] + FPMADDHI[31:0]FPMADDLO[31:0]` |
|                        | `FPMADDHI <- 0`                                                                         |
|                        | `FPMADDLO <- 0`                                                                         |
| `lf.mul.d rD,rA,rB`    | `rD[63:0] <- rA[63:0] * rB[63:0]`                                                       |
| `lf.mul.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] * rB[31:0]`                                                       |
|                        | `rD[63:32] <- 0`                                                                        |
| `lf.rem.d rD,rA,rB`    | `rD[63:0] <- rA[63:0] % rB[63:0]`                                                       |
| `lf.rem.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] % rB[31:0]`                                                       |
|                        | `rD[63:32] <- 0`                                                                        |
| `lf.sfeq.d rA,rB`      | `SR[F] <- rA[63:0] == rB[63:0]`                                                         |
| `lf.sfeq.s rA,rB`      | `SR[F] <- rA[31:0] == rB[31:0]`                                                         |
| `lf.sfge.d rA,rB`      | `SR[F] <- rA[63:0] >= rB[63:0]`                                                         |
| `lf.sfge.s rA,rB`      | `SR[F] <- rA[31:0] >= rB[31:0]`                                                         |
| `lf.sfgt.d rA,rB`      | `SR[F] <- rA[63:0] > rB[63:0]`                                                          |
| `lf.sfgt.s rA,rB`      | `SR[F] <- rA[31:0] > rB[31:0]`                                                          |
| `lf.sfle.d rA,rB`      | `SR[F] <- rA[63:0] <= rB[63:0]`                                                         |
| `lf.sfle.s rA,rB`      | `SR[F] <- rA[31:0] <= rB[31:0]`                                                         |
| `lf.sflt.d rA,rB`      | `SR[F] <- rA[63:0] < rB[63:0]`                                                          |
| `lf.sflt.s rA,rB`      | `SR[F] <- rA[31:0] < rB[31:0]`                                                          |
| `lf.sfne.d rA,rB`      | `SR[F] <- rA[63:0] != rB[63:0]`                                                         |
| `lf.sfne.s rA,rB`      | `SR[F] <- rA[31:0] != rB[31:0]`                                                         |
| `lf.sub.d rD,rA,rB`    | `rD[63:0] <- rA[63:0] - rB[63:0]`                                                       |
| `lf.sub.s rD,rA,rB`    | `rD[31:0] <- rA[31:0] - rB[31:0]`                                                       |
|                        | `rD[63:32] <- 0`                                                                        |
| `lv.add.b rD,rA,rB`    | `rD[7:0] <- rA[7:0] + rB[7:0]`                                                          |
|                        | `rD[15:8] <- rA[15:8] + rB[15:8]`                                                       |
|                        | `rD[23:16] <- rA[23:16] + rB[23:16]`                                                    |
|                        | `rD[31:24] <- rA[31:24] + rB[31:24]`                                                    |
|                        | `rD[39:32] <- rA[39:32] + rB[39:32]`                                                    |
|                        | `rD[47:40] <- rA[47:40] + rB[47:40]`                                                    |
|                        | `rD[55:48] <- rA[55:48] + rB[55:48]`                                                    |
|                        | `rD[63:56] <- rA[63:56] + rB[63:56]`                                                    |
| `lv.add.h rD,rA,rB`    | `rD[15:0] <- rA[15:0] + rB[15:0]`                                                       |
|                        | `rD[31:16] <- rA[31:16] + rB[31:16]`                                                    |
|                        | `rD[47:32] <- rA[47:32] + rB[47:32]`                                                    |
|                        | `rD[63:48] <- rA[63:48] + rB[63:48]`                                                    |
| `lv.adds.b rD,rA,rB`   | `rD[7:0] <- sat8s(rA[7:0] + rB[7:0])`                                                   |
|                        | `rD[15:8] <- sat8s(rA[15:8] + rB[15:8])`                                                |
|                        | `rD[23:16] <- sat8s(rA[23:16] + rB[23:16])`                                             |
|                        | `rD[31:24] <- sat8s(rA[31:24] + rB[31:24])`                                             |
|                        | `rD[39:32] <- sat8s(rA[39:32] + rB[39:32])`                                             |
|                        | `rD[47:40] <- sat8s(rA[47:40] + rB[47:40])`                                             |
|                        | `rD[55:48] <- sat8s(rA[55:48] + rB[55:48])`                                             |
|                        | `rD[63:56] <- sat8s(rA[63:56] + rB[63:56])`                                             |
| `lv.adds.h rD,rA,rB`   | `rD[15:0] <- sat16s(rA[15:0] + rB[15:0])`                                               |
|                        | `rD[31:16] <- sat16s(rA[31:16] + rB[31:16])`                                            |
|                        | `rD[47:32] <- sat16s(rA[47:32] + rB[47:32])`                                            |
|                        | `rD[63:48] <- sat16s(rA[63:48] + rB[63:48])`                                            |
| `lv.addu.b rD,rA,rB`   | `rD[7:0] <- rA[7:0] + rB[7:0]`                                                          |
|                        | `rD[15:8] <- rA[15:8] + rB[15:8]`                                                       |
|                        | `rD[23:16] <- rA[23:16] + rB[23:16]`                                                    |
|                        | `rD[31:24] <- rA[31:24] + rB[31:24]`                                                    |
|                        | `rD[39:32] <- rA[39:32] + rB[39:32]`                                                    |
|                        | `rD[47:40] <- rA[47:40] + rB[47:40]`                                                    |
|                        | `rD[55:48] <- rA[55:48] + rB[55:48]`                                                    |
|                        | `rD[63:56] <- rA[63:56] + rB[63:56]`                                                    |
| `lv.addu.h rD,rA,rB`   | `rD[15:0] <- rA[15:0] + rB[15:0]`                                                       |
|                        | `rD[31:16] <- rA[31:16] + rB[31:16]`                                                    |
|                        | `rD[47:32] <- rA[47:32] + rB[47:32]`                                                    |
|                        | `rD[63:48] <- rA[63:48] + rB[63:48]`                                                    |
| `lv.addus.b rD,rA,rB`  | `rD[7:0] <- sat8u(rA[7:0] + rB[7:0])`                                                   |
|                        | `rD[15:8] <- sat8u(rA[15:8] + rB[15:8])`                                                |
|                        | `rD[23:16] <- sat8u(rA[23:16] + rB[23:16])`                                             |
|                        | `rD[31:24] <- sat8u(rA[31:24] + rB[31:24])`                                             |
|                        | `rD[39:32] <- sat8u(rA[39:32] + rB[39:32])`                                             |
|                        | `rD[47:40] <- sat8u(rA[47:40] + rB[47:40])`                                             |
|                        | `rD[55:48] <- sat8u(rA[55:48] + rB[55:48])`                                             |
|                        | `rD[63:56] <- sat8u(rA[63:56] + rB[63:56])`                                             |
| `lv.addus.h rD,rA,rB`  | `rD[15:0] <- sat16s(rA[15:0] + rB[15:0])`                                               |
|                        | `rD[31:16] <- sat16s(rA[31:16] + rB[31:16])`                                            |
|                        | `rD[47:32] <- sat16s(rA[47:32] + rB[47:32])`                                            |
|                        | `rD[63:48] <- sat16s(rA[63:48] + rB[63:48])`                                            |
| `lv.all_eq.b rD,rA,rB` | `flag <- rA[7:0] == rB[7:0] &&`                                                         |
|                        | `rA[15:8] == rB[15:8] &&`                                                               |
|                        | `rA[23:16] == rB[23:16] &&`                                                             |
|                        | `rA[31:24] == rB[31:24] &&`                                                             |
|                        | `rA[39:32] == rB[39:32] &&`                                                             |
|                        | `rA[47:40] == rB[47:40] &&`                                                             |
|                        | `rA[55:48] == rB[55:48] &&`                                                             |
|                        | `rA[63:56] == rB[63:56]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_eq.h rD,rA,rB` | `flag <- rA[15:0] == rB[15:0] &&`                                                       |
|                        | `rA[31:16] == rB[31:16] &&`                                                             |
|                        | `rA[47:32] == rB[47:32] &&`                                                             |
|                        | `rA[63:48] == rB[63:48]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_ge.b rD,rA,rB` | `flag <- rA[7:0] >= rB[7:0] &&`                                                         |
|                        | `rA[15:8] >= rB[15:8] &&`                                                               |
|                        | `rA[23:16] >= rB[23:16] &&`                                                             |
|                        | `rA[31:24] >= rB[31:24] &&`                                                             |
|                        | `rA[39:32] >= rB[39:32] &&`                                                             |
|                        | `rA[47:40] >= rB[47:40] &&`                                                             |
|                        | `rA[55:48] >= rB[55:48] &&`                                                             |
|                        | `rA[63:56] >= rB[63:56]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_ge.h rD,rA,rB` | `flag <- rA[15:0] >= rB[15:0] &&`                                                       |
|                        | `rA[31:16] >= rB[31:16] &&`                                                             |
|                        | `rA[47:32] >= rB[47:32] &&`                                                             |
|                        | `rA[63:48] >= rB[63:48]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_gt.b rD,rA,rB` | `flag <- rA[7:0] > rB[7:0] &&`                                                          |
|                        | `rA[15:8] > rB[15:8] &&`                                                                |
|                        | `rA[23:16] > rB[23:16] &&`                                                              |
|                        | `rA[31:24] > rB[31:24] &&`                                                              |
|                        | `rA[39:32] > rB[39:32] &&`                                                              |
|                        | `rA[47:40] > rB[47:40] &&`                                                              |
|                        | `rA[55:48] > rB[55:48] &&`                                                              |
|                        | `rA[63:56] > rB[63:56]`                                                                 |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_gt.h rD,rA,rB` | `flag <- rA[15:0] > rB[15:0] &&`                                                        |
|                        | `rA[31:16] > rB[31:16] &&`                                                              |
|                        | `rA[47:32] > rB[47:32] &&`                                                              |
|                        | `rA[63:48] > rB[63:48]`                                                                 |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_le.b rD,rA,rB` | `flag <- rA[7:0] <= rB[7:0] &&`                                                         |
|                        | `rA[15:8] <= rB[15:8] &&`                                                               |
|                        | `rA[23:16] <= rB[23:16] &&`                                                             |
|                        | `rA[31:24] <= rB[31:24] &&`                                                             |
|                        | `rA[39:32] <= rB[39:32] &&`                                                             |
|                        | `rA[47:40] <= rB[47:40] &&`                                                             |
|                        | `rA[55:48] <= rB[55:48] &&`                                                             |
|                        | `rA[63:56] <= rB[63:56]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_le.h rD,rA,rB` | `flag <- rA[15:0] <= rB[15:0] &&`                                                       |
|                        | `rA[31:16] <= rB[31:16] &&`                                                             |
|                        | `rA[47:32] <= rB[47:32] &&`                                                             |
|                        | `rA[63:48] <= rB[63:48]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_lt.b rD,rA,rB` | `flag <- rA[7:0] < rB[7:0] &&`                                                          |
|                        | `rA[15:8] < rB[15:8] &&`                                                                |
|                        | `rA[23:16] < rB[23:16] &&`                                                              |
|                        | `rA[31:24] < rB[31:24] &&`                                                              |
|                        | `rA[39:32] < rB[39:32] &&`                                                              |
|                        | `rA[47:40] < rB[47:40] &&`                                                              |
|                        | `rA[55:48] < rB[55:48] &&`                                                              |
|                        | `rA[63:56] < rB[63:56]`                                                                 |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_lt.h rD,rA,rB` | `flag <- rA[15:0] < rB[15:0] &&`                                                        |
|                        | `rA[31:16] < rB[31:16] &&`                                                              |
|                        | `rA[47:32] < rB[47:32] &&`                                                              |
|                        | `rA[63:48] < rB[63:48]`                                                                 |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_ne.b rD,rA,rB` | `flag <- rA[7:0] != rB[7:0] &&`                                                         |
|                        | `rA[15:8] != rB[15:8] &&`                                                               |
|                        | `rA[23:16] != rB[23:16] &&`                                                             |
|                        | `rA[31:24] != rB[31:24] &&`                                                             |
|                        | `rA[39:32] != rB[39:32] &&`                                                             |
|                        | `rA[47:40] != rB[47:40] &&`                                                             |
|                        | `rA[55:48] != rB[55:48] &&`                                                             |
|                        | `rA[63:56] != rB[63:56]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.all_ne.h rD,rA,rB` | `flag <- rA[15:0] != rB[15:0] &&`                                                       |
|                        | `rA[31:16] != rB[31:16] &&`                                                             |
|                        | `rA[47:32] != rB[47:32] &&`                                                             |
|                        | `rA[63:48] != rB[63:48]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.and rD,rA,rB`      | `rD[63:0] <- rA[63:0] AND rB[63:0]`                                                     |
| `lv.any_eq.b rD,rA,rB` | `flag <- rA[7:0] == rB[7:0] ||`                                                         |
|                        | `rA[15:8] == rB[15:8] ||`                                                               |
|                        | `rA[23:16] == rB[23:16] ||`                                                             |
|                        | `rA[31:24] == rB[31:24] ||`                                                             |
|                        | `rA[39:32] == rB[39:32] ||`                                                             |
|                        | `rA[47:40] == rB[47:40] ||`                                                             |
|                        | `rA[55:48] == rB[55:48] ||`                                                             |
|                        | `rA[63:56] == rB[63:56]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_eq.h rD,rA,rB` | `flag <- rA[15:0] == rB[15:0] ||`                                                       |
|                        | `rA[31:16] == rB[31:16] ||`                                                             |
|                        | `rA[47:32] == rB[47:32] ||`                                                             |
|                        | `rA[63:48] == rB[63:48]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_ge.b rD,rA,rB` | `flag <- rA[7:0] >= rB[7:0] ||`                                                         |
|                        | `rA[15:8] >= rB[15:8] ||`                                                               |
|                        | `rA[23:16] >= rB[23:16] ||`                                                             |
|                        | `rA[31:24] >= rB[31:24] ||`                                                             |
|                        | `rA[39:32] >= rB[39:32] ||`                                                             |
|                        | `rA[47:40] >= rB[47:40] ||`                                                             |
|                        | `rA[55:48] >= rB[55:48] ||`                                                             |
|                        | `rA[63:56] >= rB[63:56]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_ge.h rD,rA,rB` | `flag <- rA[15:0] >= rB[15:0] ||`                                                       |
|                        | `rA[31:16] >= rB[31:16] ||`                                                             |
|                        | `rA[47:32] >= rB[47:32] ||`                                                             |
|                        | `rA[63:48] >= rB[63:48]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_gt.b rD,rA,rB` | `flag <- rA[7:0] > rB[7:0] ||`                                                          |
|                        | `rA[15:8] > rB[15:8] ||`                                                                |
|                        | `rA[23:16] > rB[23:16] ||`                                                              |
|                        | `rA[31:24] > rB[31:24] ||`                                                              |
|                        | `rA[39:32] > rB[39:32] ||`                                                              |
|                        | `rA[47:40] > rB[47:40] ||`                                                              |
|                        | `rA[55:48] > rB[55:48] ||`                                                              |
|                        | `rA[63:56] > rB[63:56]`                                                                 |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_gt.h rD,rA,rB` | `flag <- rA[15:0] > rB[15:0] ||`                                                        |
|                        | `rA[31:16] > rB[31:16] ||`                                                              |
|                        | `rA[47:32] > rB[47:32] ||`                                                              |
|                        | `rA[63:48] > rB[63:48]`                                                                 |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_le.b rD,rA,rB` | `flag <- rA[7:0] <= rB[7:0] ||`                                                         |
|                        | `rA[15:8] <= rB[15:8] ||`                                                               |
|                        | `rA[23:16] <= rB[23:16] ||`                                                             |
|                        | `rA[31:24] <= rB[31:24] ||`                                                             |
|                        | `rA[39:32] <= rB[39:32] ||`                                                             |
|                        | `rA[47:40] <= rB[47:40] ||`                                                             |
|                        | `rA[55:48] <= rB[55:48] ||`                                                             |
|                        | `rA[63:56] <= rB[63:56]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_le.h rD,rA,rB` | `flag <- rA[15:0] <= rB[15:0] ||`                                                       |
|                        | `rA[31:16] <= rB[31:16] ||`                                                             |
|                        | `rA[47:32] <= rB[47:32] ||`                                                             |
|                        | `rA[63:48] <= rB[63:48]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_lt.b rD,rA,rB` | `flag <- rA[7:0] < rB[7:0] ||`                                                          |
|                        | `rA[15:8] < rB[15:8] ||`                                                                |
|                        | `rA[23:16] < rB[23:16] ||`                                                              |
|                        | `rA[31:24] < rB[31:24] ||`                                                              |
|                        | `rA[39:32] < rB[39:32] ||`                                                              |
|                        | `rA[47:40] < rB[47:40] ||`                                                              |
|                        | `rA[55:48] < rB[55:48] ||`                                                              |
|                        | `rA[63:56] < rB[63:56]`                                                                 |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_lt.h rD,rA,rB` | `flag <- rA[15:0] < rB[15:0] ||`                                                        |
|                        | `rA[31:16] < rB[31:16] ||`                                                              |
|                        | `rA[47:32] < rB[47:32] ||`                                                              |
|                        | `rA[63:48] < rB[63:48]`                                                                 |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_ne.b rD,rA,rB` | `flag <- rA[7:0] != rB[7:0] ||`                                                         |
|                        | `rA[15:8] != rB[15:8] ||`                                                               |
|                        | `rA[23:16] != rB[23:16] ||`                                                             |
|                        | `rA[31:24] != rB[31:24] ||`                                                             |
|                        | `rA[39:32] != rB[39:32] ||`                                                             |
|                        | `rA[47:40] != rB[47:40] ||`                                                             |
|                        | `rA[55:48] != rB[55:48] ||`                                                             |
|                        | `rA[63:56] != rB[63:56]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.any_ne.h rD,rA,rB` | `flag <- rA[15:0] != rB[15:0] ||`                                                       |
|                        | `rA[31:16] != rB[31:16] ||`                                                             |
|                        | `rA[47:32] != rB[47:32] ||`                                                             |
|                        | `rA[63:48] != rB[63:48]`                                                                |
|                        | `rD[63:0] <- repl(flag)`                                                                |
| `lv.avg.b rD,rA,rB`    | `rD[7:0] <- (rA[7:0] + rB[7:0]) >> 1`                                                   |
|                        | `rD[15:8] <- (rA[15:8] + rB[15:8]) >> 1`                                                |
|                        | `rD[23:16] <- (rA[23:16] + rB[23:16]) >> 1`                                             |
|                        | `rD[31:24] <- (rA[31:24] + rB[31:24]) >> 1`                                             |
|                        | `rD[39:32] <- (rA[39:32] + rB[39:32]) >> 1`                                             |
|                        | `rD[47:40] <- (rA[47:40] + rB[47:40]) >> 1`                                             |
|                        | `rD[55:48] <- (rA[55:48] + rB[55:48]) >> 1`                                             |
|                        | `rD[63:56] <- (rA[63:56] + rB[63:56]) >> 1`                                             |
| `lv.avg.h rD,rA,rB`    | `rD[15:0] <- (rA[15:0] + rB[15:0]) >> 1`                                                |
|                        | `rD[31:16] <- (rA[31:16] + rB[31:16]) >> 1`                                             |
|                        | `rD[47:32] <- (rA[47:32] + rB[47:32]) >> 1`                                             |
|                        | `rD[63:48] <- (rA[63:48] + rB[63:48]) >> 1`                                             |
| `lv.cmp_eq.b rD,rA,rB` | `rD[7:0] <- repl(rA[7:0] == rB[7:0])`                                                   |
|                        | `rD[15:8] <- repl(rA[15:8] == rB[15:8])`                                                |
|                        | `rD[23:16] <- repl(rA[23:16] == rB[23:16])`                                             |
|                        | `rD[31:24] <- repl(rA[31:24] == rB[31:24])`                                             |
|                        | `rD[39:32] <- repl(rA[39:32] == rB[39:32])`                                             |
|                        | `rD[47:40] <- repl(rA[47:40] == rB[47:40])`                                             |
|                        | `rD[55:48] <- repl(rA[55:48] == rB[55:48])`                                             |
|                        | `rD[63:56] <- repl(rA[63:56] == rB[63:56])`                                             |
| `lv.cmp_eq.h rD,rA,rB` | `rD[15:0] <- repl(rA[15:0] == rB[15:0])`                                                |
|                        | `rD[31:16] <- repl(rA[31:16] == rB[31:16])`                                             |
|                        | `rD[47:32] <- repl(rA[47:32] == rB[47:32])`                                             |
|                        | `rD[63:48] <- repl(rA[63:48] == rB[63:48])`                                             |
| `lv.cmp_ge.b rD,rA,rB` | `rD[7:0] <- repl(rA[7:0] >= rB[7:0])`                                                   |
|                        | `rD[15:8] <- repl(rA[15:8] >= rB[15:8])`                                                |
|                        | `rD[23:16] <- repl(rA[23:16] >= rB[23:16])`                                             |
|                        | `rD[31:24] <- repl(rA[31:24] >= rB[31:24])`                                             |
|                        | `rD[39:32] <- repl(rA[39:32] >= rB[39:32])`                                             |
|                        | `rD[47:40] <- repl(rA[47:40] >= rB[47:40])`                                             |
|                        | `rD[55:48] <- repl(rA[55:48] >= rB[55:48])`                                             |
|                        | `rD[63:56] <- repl(rA[63:56] >= rB[63:56])`                                             |
| `lv.cmp_ge.h rD,rA,rB` | `rD[15:0] <- repl(rA[15:0] >= rB[15:0])`                                                |
|                        | `rD[31:16] <- repl(rA[31:16] >= rB[31:16])`                                             |
|                        | `rD[47:32] <- repl(rA[47:32] >= rB[47:32])`                                             |
|                        | `rD[63:48] <- repl(rA[63:48] >= rB[63:48])`                                             |
| `lv.cmp_gt.b rD,rA,rB` | `rD[7:0] <- repl(rA[7:0] > rB[7:0])`                                                    |
|                        | `rD[15:8] <- repl(rA[15:8] > rB[15:8])`                                                 |
|                        | `rD[23:16] <- repl(rA[23:16] > rB[23:16])`                                              |
|                        | `rD[31:24] <- repl(rA[31:24] > rB[31:24])`                                              |
|                        | `rD[39:32] <- repl(rA[39:32] > rB[39:32])`                                              |
|                        | `rD[47:40] <- repl(rA[47:40] > rB[47:40])`                                              |
|                        | `rD[55:48] <- repl(rA[55:48] > rB[55:48])`                                              |
|                        | `rD[63:56] <- repl(rA[63:56] > rB[63:56])`                                              |
| `lv.cmp_gt.h rD,rA,rB` | `rD[15:0] <- repl(rA[15:0] > rB[15:0])`                                                 |
|                        | `rD[31:16] <- repl(rA[31:16] > rB[31:16])`                                              |
|                        | `rD[47:32] <- repl(rA[47:32] > rB[47:32])`                                              |
|                        | `rD[63:48] <- repl(rA[63:48] > rB[63:48])`                                              |
| `lv.cmp_le.b rD,rA,rB` | `rD[7:0] <- repl(rA[7:0] <= rB[7:0])`                                                   |
|                        | `rD[15:8] <- repl(rA[15:8] <= rB[15:8])`                                                |
|                        | `rD[23:16] <- repl(rA[23:16] <= rB[23:16])`                                             |
|                        | `rD[31:24] <- repl(rA[31:24] <= rB[31:24])`                                             |
|                        | `rD[39:32] <- repl(rA[39:32] <= rB[39:32])`                                             |
|                        | `rD[47:40] <- repl(rA[47:40] <= rB[47:40])`                                             |
|                        | `rD[55:48] <- repl(rA[55:48] <= rB[55:48])`                                             |
|                        | `rD[63:56] <- repl(rA[63:56] <= rB[63:56])`                                             |
| `lv.cmp_le.h rD,rA,rB` | `rD[15:0] <- repl(rA[15:0] <= rB[15:0])`                                                |
|                        | `rD[31:16] <- repl(rA[31:16] <= rB[31:16])`                                             |
|                        | `rD[47:32] <- repl(rA[47:32] <= rB[47:32])`                                             |
|                        | `rD[63:48] <- repl(rA[63:48] <= rB[63:48])`                                             |
| `lv.cmp_lt.b rD,rA,rB` | `rD[7:0] <- repl(rA[7:0] <= rB[7:0])`                                                   |
|                        | `rD[15:8] <- repl(rA[15:8] <= rB[15:8])`                                                |
|                        | `rD[23:16] <- repl(rA[23:16] <= rB[23:16])`                                             |
|                        | `rD[31:24] <- repl(rA[31:24] <= rB[31:24])`                                             |
|                        | `rD[39:32] <- repl(rA[39:32] <= rB[39:32])`                                             |
|                        | `rD[47:40] <- repl(rA[47:40] <= rB[47:40])`                                             |
|                        | `rD[55:48] <- repl(rA[55:48] <= rB[55:48])`                                             |
|                        | `rD[63:56] <- repl(rA[63:56] <= rB[63:56])`                                             |
| `lv.cmp_lt.h rD,rA,rB` | `rD[15:0] <- repl(rA[15:0] <= rB[15:0])`                                                |
|                        | `rD[31:16] <- repl(rA[31:16] <= rB[31:16])`                                             |
|                        | `rD[47:32] <- repl(rA[47:32] <= rB[47:32])`                                             |
|                        | `rD[63:48] <- repl(rA[63:48] <= rB[63:48])`                                             |
| `lv.cmp_ne.b rD,rA,rB` | `rD[7:0] <- repl(rA[7:0] != rB[7:0])`                                                   |
|                        | `rD[15:8] <- repl(rA[15:8] != rB[15:8])`                                                |
|                        | `rD[23:16] <- repl(rA[23:16] != rB[23:16])`                                             |
|                        | `rD[31:24] <- repl(rA[31:24] != rB[31:24])`                                             |
|                        | `rD[39:32] <- repl(rA[39:32] != rB[39:32])`                                             |
|                        | `rD[47:40] <- repl(rA[47:40] != rB[47:40])`                                             |
|                        | `rD[55:48] <- repl(rA[55:48] != rB[55:48])`                                             |
|                        | `rD[63:56] <- repl(rA[63:56] != rB[63:56])`                                             |
| `lv.cmp_ne.h rD,rA,rB` | `rD[15:0] <- repl(rA[15:0] != rB[15:0])`                                                |
|                        | `rD[31:16] <- repl(rA[31:16] != rB[31:16])`                                             |
|                        | `rD[47:32] <- repl(rA[47:32] != rB[47:32])`                                             |
|                        | `rD[63:48] <- repl(rA[63:48] != rB[63:48])`                                             |
| `lv.cust1 `            | `N/A`                                                                                   |
| `lv.cust2 `            | `N/A`                                                                                   |
| `lv.cust3 `            | `N/A`                                                                                   |
| `lv.cust4 `            | `N/A`                                                                                   |
| `lv.madds.h rD,rA,rB`  | `rD[15:0] <- sat32s(rA[15:0] * rB[15:0] + VMACLO[31:0])`                                |
|                        | `rD[31:16] <- sat32s(rA[31:16] * rB[31:16] + VMACLO[63:32])`                            |
|                        | `rD[47:32] <- sat32s(rA[47:32] * rB[47:32] + VMACHI[31:0])`                             |
|                        | `rD[63:48] <- sat32s(rA[63:48] * rB[63:48] + VMACHI[63:32])`                            |
| `lv.max.b rD,rA,rB`    | `rD[7:0] <- rA[7:0] > rB[7:0] ? rA[7:0] : rB[7:0]`                                      |
|                        | `rD[15:8] <- rA[15:8] > rB[15:8] ? rA[15:8] : rB[15:8]`                                 |
|                        | `rD[23:16] <- rA[23:16] > rB[23:16] ? rA[23:16] : rB[23:16]`                            |
|                        | `rD[31:24] <- rA[31:24] > rB[31:24] ? rA[31:24] : rB[31:24]`                            |
|                        | `rD[39:32] <- rA[39:32] > rB[39:32] ? rA[39:32] : rB[39:32]`                            |
|                        | `rD[47:40] <- rA[47:40] > rB[47:40] ? rA[47:40] : rB[47:40]`                            |
|                        | `rD[55:48] <- rA[55:48] > rB[55:48] ? rA[55:48] : rB[55:48]`                            |
|                        | `rD[63:56] <- rA[63:56] > rB[63:56] ? rA[63:56] : rB[63:56]`                            |
| `lv.max.h rD,rA,rB`    | `rD[15:0] <- rA[15:0] > rB[15:0] ? rA[15:0] : rB[15:0]`                                 |
|                        | `rD[31:16] <- rA[31:16] > rB[31:16] ? rA[31:16] : rB[31:16]`                            |
|                        | `rD[47:32] <- rA[47:32] > rB[47:32] ? rA[47:32] : rB[47:32]`                            |
|                        | `rD[63:48] <- rA[63:48] > rB[63:48] ? rA[63:48] : rB[63:48]`                            |
| `lv.merge.b rD,rA,rB`  | `rD[7:0] <- rB[7:0]`                                                                    |
|                        | `rD[15:8] <- rA[15:8]`                                                                  |
|                        | `rD[23:16] <- rB[23:16]`                                                                |
|                        | `rD[31:24] <- rA[31:24]`                                                                |
|                        | `rD[39:32] <- rB[39:32]`                                                                |
|                        | `rD[47:40] <- rA[47:40]`                                                                |
|                        | `rD[55:48] <- rB[55:48]`                                                                |
|                        | `rD[63:56] <- rA[63:56]`                                                                |
| `lv.merge.h rD,rA,rB`  | `rD[15:0] <- rB[15:0]`                                                                  |
|                        | `rD[31:16] <- rA[31:16]`                                                                |
|                        | `rD[47:32] <- rB[47:32]`                                                                |
|                        | `rD[63:48] <- rA[63:48]`                                                                |
| `lv.min.b rD,rA,rB`    | `rD[7:0] <- rA[7:0] < rB[7:0] ? rA[7:0] : rB[7:0]`                                      |
|                        | `rD[15:8] <- rA[15:8] < rB[15:8] ? rA[15:8] : rB[15:8]`                                 |
|                        | `rD[23:16] <- rA[23:16] < rB[23:16] ? rA[23:16] : rB[23:16]`                            |
|                        | `rD[31:24] <- rA[31:24] < rB[31:24] ? rA[31:24] : rB[31:24]`                            |
|                        | `rD[39:32] <- rA[39:32] < rB[39:32] ? rA[39:32] : rB[39:32]`                            |
|                        | `rD[47:40] <- rA[47:40] < rB[47:40] ? rA[47:40] : rB[47:40]`                            |
|                        | `rD[55:48] <- rA[55:48] < rB[55:48] ? rA[55:48] : rB[55:48]`                            |
|                        | `rD[63:56] <- rA[63:56] < rB[63:56] ? rA[63:56] : rB[63:56]`                            |
| `lv.min.h rD,rA,rB`    | `rD[15:0] <- rA[15:0] < rB[15:0] ? rA[15:0] : rB[15:0]`                                 |
|                        | `rD[31:16] <- rA[31:16] < rB[31:16] ? rA[31:16] : rB[31:16]`                            |
|                        | `rD[47:32] <- rA[47:32] < rB[47:32] ? rA[47:32] : rB[47:32]`                            |
|                        | `rD[63:48] <- rA[63:48] < rB[63:48] ? rA[63:48] : rB[63:48]`                            |
| `lv.msubs.h rD,rA,rB`  | `rD[15:0] <- sat32s(VMACLO[31:0] - rA[15:0] * rB[15:0])`                                |
|                        | `rD[31:16] <- sat32s(VMACLO[63:32] - rA[31:16] * rB[31:16])`                            |
|                        | `rD[47:32] <- sat32s(VMACHI[31:0] - rA[47:32] * rB[47:32])`                             |
|                        | `rD[63:48] <- sat32s(VMACHI[63:32] - rA[63:48] * rB[63:48])`                            |
| `lv.muls.h rD,rA,rB`   | `rD[15:0] <- sat16s(rA[15:0] * rB[15:0])`                                               |
|                        | `rD[31:16] <- sat16s(rA[31:16] * rB[31:16])`                                            |
|                        | `rD[47:32] <- sat16s(rA[47:32] * rB[47:32])`                                            |
|                        | `rD[63:48] <- sat16s(rA[63:48] * rB[63:48])`                                            |
| `lv.nand rD,rA,rB`     | `rD[63:0] <- rA[63:0] NAND rB[63:0]`                                                    |
| `lv.nor rD,rA,rB`      | `rD[63:0] <- rA[63:0] NOR rB[63:0]`                                                     |
| `lv.or rD,rA,rB`       | `rD[63:0] <- rA[63:0] OR rB[63:0]`                                                      |
| `lv.pack.b rD,rA,rB`   | `rD[3:0] <- rB[3:0]`                                                                    |
|                        | `rD[7:4] <- rB[11:8]`                                                                   |
|                        | `rD[11:8] <- rB[19:16]`                                                                 |
|                        | `rD[15:12] <- rB[27:24]`                                                                |
|                        | `rD[19:16] <- rB[35:32]`                                                                |
|                        | `rD[23:20] <- rB[43:40]`                                                                |
|                        | `rD[27:24] <- rB[51:48]`                                                                |
|                        | `rD[31:28] <- rB[59:56]`                                                                |
|                        | `rD[35:32] <- rA[3:0]`                                                                  |
|                        | `rD[39:36] <- rA[11:8]`                                                                 |
|                        | `rD[43:40] <- rA[19:16]`                                                                |
|                        | `rD[47:44] <- rA[27:24]`                                                                |
|                        | `rD[51:48] <- rA[35:32]`                                                                |
|                        | `rD[55:52] <- rA[43:40]`                                                                |
|                        | `rD[59:56] <- rA[51:48]`                                                                |
|                        | `rD[63:60] <- rA[59:56]`                                                                |
| `lv.pack.h rD,rA,rB`   | `rD[7:0] <- rB[7:0]`                                                                    |
|                        | `rD[15:8] <- rB[23:16]`                                                                 |
|                        | `rD[23:16] <- rB[39:32]`                                                                |
|                        | `rD[31:24] <- rB[55:48]`                                                                |
|                        | `rD[39:32] <- rA[7:0]`                                                                  |
|                        | `rD[47:40] <- rA[23:16]`                                                                |
|                        | `rD[55:48] <- rA[39:32]`                                                                |
|                        | `rD[63:56] <- rA[55:48]`                                                                |
| `lv.packs.b rD,rA,rB`  | `rD[3:0] <- sat4s(rB[7:0])`                                                             |
|                        | `rD[7:4] <- sat4s(rB[15:8])`                                                            |
|                        | `rD[11:8] <- sat4s(rB[23:16])`                                                          |
|                        | `rD[15:12] <- sat4s(rB[31:24])`                                                         |
|                        | `rD[19:16] <- sat4s(rB[39:32])`                                                         |
|                        | `rD[23:20] <- sat4s(rB[47:40])`                                                         |
|                        | `rD[27:24] <- sat4s(rB[55:48])`                                                         |
|                        | `rD[31:28] <- sat4s(rB[63:56])`                                                         |
|                        | `rD[35:32] <- sat4s(rA[7:0])`                                                           |
|                        | `rD[39:36] <- sat4s(rA[15:8])`                                                          |
|                        | `rD[43:40] <- sat4s(rA[23:16])`                                                         |
|                        | `rD[47:44] <- sat4s(rA[31:24])`                                                         |
|                        | `rD[51:48] <- sat4s(rA[39:32])`                                                         |
|                        | `rD[55:52] <- sat4s(rA[47:40])`                                                         |
|                        | `rD[59:56] <- sat4s(rA[55:48])`                                                         |
|                        | `rD[63:60] <- sat4s(rA[63:56])`                                                         |
| `lv.packs.h rD,rA,rB`  | `rD[7:0] <- sat8s(rB[15:0])`                                                            |
|                        | `rD[15:8] <- sat8s(rB[31:16])`                                                          |
|                        | `rD[23:16] <- sat8s(rB[47:32])`                                                         |
|                        | `rD[31:24] <- sat8s(rB[63:48])`                                                         |
|                        | `rD[39:32] <- sat8s(rA[15:0])`                                                          |
|                        | `rD[47:40] <- sat8s(rA[31:16])`                                                         |
|                        | `rD[55:48] <- sat8s(rA[47:32])`                                                         |
|                        | `rD[63:56] <- sat8s(rA[63:48])`                                                         |
| `lv.packus.b rD,rA,rB` | `rD[3:0] <- sat4u(rB[7:0])`                                                             |
|                        | `rD[7:4] <- sat4u(rB[15:8])`                                                            |
|                        | `rD[11:8] <- sat4u(rB[23:16])`                                                          |
|                        | `rD[15:12] <- sat4u(rB[31:24])`                                                         |
|                        | `rD[19:16] <- sat4u(rB[39:32])`                                                         |
|                        | `rD[23:20] <- sat4u(rB[47:40])`                                                         |
|                        | `rD[27:24] <- sat4u(rB[55:48])`                                                         |
|                        | `rD[31:28] <- sat4u(rB[63:56])`                                                         |
|                        | `rD[35:32] <- sat4u(rA[7:0])`                                                           |
|                        | `rD[39:36] <- sat4u(rA[15:8])`                                                          |
|                        | `rD[43:40] <- sat4u(rA[23:16])`                                                         |
|                        | `rD[47:44] <- sat4u(rA[31:24])`                                                         |
|                        | `rD[51:48] <- sat4u(rA[39:32])`                                                         |
|                        | `rD[55:52] <- sat4u(rA[47:40])`                                                         |
|                        | `rD[59:56] <- sat4u(rA[55:48])`                                                         |
|                        | `rD[63:60] <- sat4u(rA[63:56])`                                                         |
| `lv.packus.h rD,rA,rB` | `rD[7:0] <- sat8u(rB[15:0])`                                                            |
|                        | `rD[15:8] <- sat8u(rB[31:16])`                                                          |
|                        | `rD[23:16] <- sat8u(rB[47:32])`                                                         |
|                        | `rD[31:24] <- sat8u(rB[63:48])`                                                         |
|                        | `rD[39:32] <- sat8u(rA[15:0])`                                                          |
|                        | `rD[47:40] <- sat8u(rA[31:16])`                                                         |
|                        | `rD[55:48] <- sat8u(rA[47:32])`                                                         |
|                        | `rD[63:56] <- sat8u(rA[63:48])`                                                         |
| `lv.perm.n rD,rA,rB`   | `rD[3:0] <- rA[rB[3:0]*4+3:rB[3:0]*4]`                                                  |
|                        | `rD[7:4] <- rA[rB[7:4]*4+3:rB[7:4]*4]`                                                  |
|                        | `rD[11:8] <- rA[rB[11:8]*4+3:rB[11:8]*4]`                                               |
|                        | `rD[15:12] <- rA[rB[15:12]*4+3:rB[15:12]*4]`                                            |
|                        | `rD[19:16] <- rA[rB[19:16]*4+3:rB[19:16]*4]`                                            |
|                        | `rD[23:20] <- rA[rB[23:20]*4+3:rB[23:20]*4]`                                            |
|                        | `rD[27:24] <- rA[rB[27:24]*4+3:rB[27:24]*4]`                                            |
|                        | `rD[31:28] <- rA[rB[31:28]*4+3:rB[31:28]*4]`                                            |
|                        | `rD[35:32] <- rA[rB[35:32]*4+3:rB[35:32]*4]`                                            |
|                        | `rD[39:36] <- rA[rB[39:36]*4+3:rB[39:36]*4]`                                            |
|                        | `rD[43:40] <- rA[rB[43:40]*4+3:rB[43:40]*4]`                                            |
|                        | `rD[47:44] <- rA[rB[47:44]*4+3:rB[47:44]*4]`                                            |
|                        | `rD[51:48] <- rA[rB[51:48]*4+3:rB[51:48]*4]`                                            |
|                        | `rD[55:52] <- rA[rB[55:52]*4+3:rB[55:52]*4]`                                            |
|                        | `rD[59:56] <- rA[rB[59:56]*4+3:rB[59:56]*4]`                                            |
|                        | `rD[63:60] <- rA[rB[63:60]*4+3:rB[63:60]*4]`                                            |
| `lv.rl.b rD,rA,rB`     | `rD[7:0] <- rA[7:0] rl rB[2:0]`                                                         |
|                        | `rD[15:8] <- rA[15:8] rl rB[10:8]`                                                      |
|                        | `rD[23:16] <- rA[23:16] rl rB[18:16]`                                                   |
|                        | `rD[31:24] <- rA[31:24] rl rB[26:24]`                                                   |
|                        | `rD[39:32] <- rA[39:32] rl rB[34:32]`                                                   |
|                        | `rD[47:40] <- rA[47:40] rl rB[42:40]`                                                   |
|                        | `rD[55:48] <- rA[55:48] rl rB[50:48]`                                                   |
|                        | `rD[63:56] <- rA[63:56] rl rB[58:56]`                                                   |
| `lv.rl.h rD,rA,rB`     | `rD[15:0] <- rA[15:0] rl rB[3:0]`                                                       |
|                        | `rD[31:16] <- rA[31:16] rl rB[19:16]`                                                   |
|                        | `rD[47:32] <- rA[47:32] rl rB[35:32]`                                                   |
|                        | `rD[63:48] <- rA[63:48] rl rB[51:48]`                                                   |
| `lv.sll rD,rA,rB`      | `rD[63:0] <- rA[63:0] << rB[2:0]`                                                       |
| `lv.sll.b rD,rA,rB`    | `rD[7:0] <- rA[7:0] << rB[2:0]`                                                         |
|                        | `rD[15:8] <- rA[15:8] << rB[10:8]`                                                      |
|                        | `rD[23:16] <- rA[23:16] << rB[18:16]`                                                   |
|                        | `rD[31:24] <- rA[31:24] << rB[26:24]`                                                   |
|                        | `rD[39:32] <- rA[39:32] << rB[34:32]`                                                   |
|                        | `rD[47:40] <- rA[47:40] << rB[42:40]`                                                   |
|                        | `rD[55:48] <- rA[55:48] << rB[50:48]`                                                   |
|                        | `rD[63:56] <- rA[63:56] << rB[58:56]`                                                   |
| `lv.sll.h rD,rA,rB`    | `rD[15:0] <- rA[15:0] << rB[3:0]`                                                       |
|                        | `rD[31:16] <- rA[31:16] << rB[19:16]`                                                   |
|                        | `rD[47:32] <- rA[47:32] << rB[35:32]`                                                   |
|                        | `rD[63:48] <- rA[63:48] << rB[51:48]`                                                   |
| `lv.sra.b rD,rA,rB`    | `rD[7:0] <- rA[7:0] sra rB[2:0]`                                                        |
|                        | `rD[15:8] <- rA[15:8] sra rB[10:8]`                                                     |
|                        | `rD[23:16] <- rA[23:16] sra rB[18:16]`                                                  |
|                        | `rD[31:24] <- rA[31:24] sra rB[26:24]`                                                  |
|                        | `rD[39:32] <- rA[39:32] sra rB[34:32]`                                                  |
|                        | `rD[47:40] <- rA[47:40] sra rB[42:40]`                                                  |
|                        | `rD[55:48] <- rA[55:48] sra rB[50:48]`                                                  |
|                        | `rD[63:56] <- rA[63:56] sra rB[58:56]`                                                  |
| `lv.sra.h rD,rA,rB`    | `rD[15:0] <- rA[15:0] sra rB[3:0]`                                                      |
|                        | `rD[31:16] <- rA[31:16] sra rB[19:16]`                                                  |
|                        | `rD[47:32] <- rA[47:32] sra rB[35:32]`                                                  |
|                        | `rD[63:48] <- rA[63:48] sra rB[51:48]`                                                  |
| `lv.srl rD,rA,rB`      | `rD[63:0] <- rA[63:0] >> rB[2:0]`                                                       |
| `lv.srl.b rD,rA,rB`    | `rD[7:0] <- rA[7:0] >> rB[2:0]`                                                         |
|                        | `rD[15:8] <- rA[15:8] >> rB[10:8]`                                                      |
|                        | `rD[23:16] <- rA[23:16] >> rB[18:16]`                                                   |
|                        | `rD[31:24] <- rA[31:24] >> rB[26:24]`                                                   |
|                        | `rD[39:32] <- rA[39:32] >> rB[34:32]`                                                   |
|                        | `rD[47:40] <- rA[47:40] >> rB[42:40]`                                                   |
|                        | `rD[55:48] <- rA[55:48] >> rB[50:48]`                                                   |
|                        | `rD[63:56] <- rA[63:56] >> rB[58:56]`                                                   |
| `lv.srl.h rD,rA,rB`    | `rD[15:0] <- rA[15:0] >> rB[3:0]`                                                       |
|                        | `rD[31:16] <- rA[31:16] >> rB[19:16]`                                                   |
|                        | `rD[47:32] <- rA[47:32] >> rB[35:32]`                                                   |
|                        | `rD[63:48] <- rA[63:48] >> rB[51:48]`                                                   |
| `lv.sub.b rD,rA,rB`    | `rD[7:0] <- rA[7:0] - rB[7:0]`                                                          |
|                        | `rD[15:8] <- rA[15:8] - rB[15:8]`                                                       |
|                        | `rD[23:16] <- rA[23:16] - rB[23:16]`                                                    |
|                        | `rD[31:24] <- rA[31:24] - rB[31:24]`                                                    |
|                        | `rD[39:32] <- rA[39:32] - rB[39:32]`                                                    |
|                        | `rD[47:40] <- rA[47:40] - rB[47:40]`                                                    |
|                        | `rD[55:48] <- rA[55:48] - rB[55:48]`                                                    |
|                        | `rD[63:56] <- rA[63:56] - rB[63:56]`                                                    |
| `lv.sub.h rD,rA,rB`    | `rD[15:0] <- rA[15:0] - rB[15:0]`                                                       |
|                        | `rD[31:16] <- rA[31:16] - rB[31:16]`                                                    |
|                        | `rD[47:32] <- rA[47:32] - rB[47:32]`                                                    |
|                        | `rD[63:48] <- rA[63:48] - rB[63:48]`                                                    |
| `lv.subs.b rD,rA,rB`   | `rD[7:0] <- sat8s(rA[7:0] - rB[7:0])`                                                   |
|                        | `rD[15:8] <- sat8s(rA[15:8] - rB[15:8])`                                                |
|                        | `rD[23:16] <- sat8s(rA[23:16] - rB[23:16])`                                             |
|                        | `rD[31:24] <- sat8s(rA[31:24] - rB[31:24])`                                             |
|                        | `rD[39:32] <- sat8s(rA[39:32] - rB[39:32])`                                             |
|                        | `rD[47:40] <- sat8s(rA[47:40] - rB[47:40])`                                             |
|                        | `rD[55:48] <- sat8s(rA[55:48] - rB[55:48])`                                             |
|                        | `rD[63:56] <- sat8s(rA[63:56] - rB[63:56])`                                             |
| `lv.subs.h rD,rA,rB`   | `rD[15:0] <- sat16s(rA[15:0] - rB[15:0])`                                               |
|                        | `rD[31:16] <- sat16s(rA[31:16] - rB[31:16])`                                            |
|                        | `rD[47:32] <- sat16s(rA[47:32] - rB[47:32])`                                            |
|                        | `rD[63:48] <- sat16s(rA[63:48] - rB[63:48])`                                            |
| `lv.subu.b rD,rA,rB`   | `rD[7:0] <- rA[7:0] - rB[7:0]`                                                          |
|                        | `rD[15:8] <- rA[15:8] - rB[15:8]`                                                       |
|                        | `rD[23:16] <- rA[23:16] - rB[23:16]`                                                    |
|                        | `rD[31:24] <- rA[31:24] - rB[31:24]`                                                    |
|                        | `rD[39:32] <- rA[39:32] - rB[39:32]`                                                    |
|                        | `rD[47:40] <- rA[47:40] - rB[47:40]`                                                    |
|                        | `rD[55:48] <- rA[55:48] - rB[55:48]`                                                    |
|                        | `rD[63:56] <- rA[63:56] - rB[63:56]`                                                    |
| `lv.subu.h rD,rA,rB`   | `rD[15:0] <- rA[15:0] - rB[15:0]`                                                       |
|                        | `rD[31:16] <- rA[31:16] - rB[31:16]`                                                    |
|                        | `rD[47:32] <- rA[47:32] - rB[47:32]`                                                    |
|                        | `rD[63:48] <- rA[63:48] - rB[63:48]`                                                    |
| `lv.subus.b rD,rA,rB`  | `rD[7:0] <- sat8u(rA[7:0] - rB[7:0])`                                                   |
|                        | `rD[15:8] <- sat8u(rA[15:8] - rB[15:8])`                                                |
|                        | `rD[23:16] <- sat8u(rA[23:16] - rB[23:16])`                                             |
|                        | `rD[31:24] <- sat8u(rA[31:24] - rB[31:24])`                                             |
|                        | `rD[39:32] <- sat8u(rA[39:32] - rB[39:32])`                                             |
|                        | `rD[47:40] <- sat8u(rA[47:40] - rB[47:40])`                                             |
|                        | `rD[55:48] <- sat8u(rA[55:48] - rB[55:48])`                                             |
|                        | `rD[63:56] <- sat8u(rA[63:56] - rB[63:56])`                                             |
| `lv.subus.h rD,rA,rB`  | `rD[15:0] <- sat16u(rA[15:0] - rB[15:0])`                                               |
|                        | `rD[31:16] <- sat16u(rA[31:16] - rB[31:16])`                                            |
|                        | `rD[47:32] <- sat16u(rA[47:32] - rB[47:32])`                                            |
|                        | `rD[63:48] <- sat16u(rA[63:48] - rB[63:48])`                                            |
| `lv.unpack.b rD,rA,rB` | `rD[7:0] <- exts(rA[3:0])`                                                              |
|                        | `rD[15:8] <- exts(rA[7:4])`                                                             |
|                        | `rD[23:16] <- exts(rA[11:8])`                                                           |
|                        | `rD[31:24] <- exts(rA[15:12])`                                                          |
|                        | `rD[39:32] <- exts(rA[19:16])`                                                          |
|                        | `rD[47:40] <- exts(rA[23:20])`                                                          |
|                        | `rD[55:48] <- exts(rA[27:24])`                                                          |
|                        | `rD[63:56] <- exts(rA[31:28])`                                                          |
| `lv.unpack.h rD,rA,rB` | `rD[15:0] <- exts(rA[7:0])`                                                             |
|                        | `rD[31:16] <- exts(rA[15:8])`                                                           |
|                        | `rD[47:32] <- exts(rA[23:16])`                                                          |
|                        | `rD[63:48] <- exts(rA[31:24])`                                                          |
| `lv.xor rD,rA,rB`      | `rD[63:0] <- rA[63:0] XOR rB[63:0]`                                                     |
: OpenRISC 64-Bit - "OpenRISC 64-Bit Base Integer Instruction Set"
