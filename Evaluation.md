# Evaluation

The following details how the workshop evaluation was done
- [Bugs](#bugs) The bugs introduced
- [Self evaluation](#self-evaluation) How to run the evaluation

## Bugs

## Fixed bugs
| ID | Function | Bug | File |
| - | -------- | --- | ---- |
| 1 | rpow | The operation will return 0 in the edge case of 0 ** 0 | bad_rpow.sol
| 2 |  mulDivUp | The operation now performs ((x * denominator)/y) instead of ((x*y)/denominator) | bad_mulDivUp_one.sol
| 3 |  sqrt | The operation's return value is increased by 1 | bad_sqrt.sol
| 4 |  unsafeMod | The operation's return value is increased by 1 | bad_unsafeMod.sol
| 5 |  unsafeDiv | The operation's return value is halved | safe_divUp.sol
| 6 |  unsafeDivUp | The operation is now "safe" because the function will revert if y is zero | bad_unsafeDiv.sol
| 7 |  mulDivUp | Instead of adding one when (x*y % denominator) > 0, we will add one when (x*y % denominator) < 0 | bad_mulDivUp_two.sol
| 8 |  mulWadDown | mulWadDown rounds Up | mulWadDownIsUp.sol
| 9 |  mulWadDown | mulWadDown always revert | bad_mulWadDownRevert.sol
| 10 |  rpow | rpow loop can only iterate 6 times | bad_rpowPrecision.sol


## Signed bugs
| ID | Function | Bug | File |
|- | -------- | --- | ---- |
| 1 | wadLn | This line `r := or(r, shl(1, lt(0x3, shr(r, x))))` is commented out | bad_wadLn.sol
| 2 | toDaysWadUnsafe | x is multiplied by 8640 instead of 86400 | bad_toDaysWadUnsafe.sol
| 3 | unsafeWadDiv | The operation is now "safe" because the function will revert if y is zero | safe_wadDiv.sol
| 4 | wadExp | This line `p = p * x + (4385272521454847904659076985693276 << 96)` is commented out | bad_wadExp.sol
| 5 | wadDiv, wadMul | Invert mul and div | bad_mul_div.sol
| 6 | Multiple functions | Use 1e16 instead of 1e18 | bad_decimals.sol
| 7 | wadLn | Revert if x>1e18 | bad_wadLNRevert.sol
| 8 | wadPow | x parameters loses its 5 most right bits | bad_wadPowPrecision.sol
| 9 | wadMul |  remove overflow check | bad_wadMulOverflow.sol
| 10 | wadExp | Return zero instead of reverting | bad_wadExpReturn0.sol



## ERC20 bugs
| ID | Function | Bug | File |
|- | -------- | --- | ---- |
| 1 | transferFrom | allowances are not decremented on transferFrom | bad_approval_check.sol
| 2 | transfer | incorrect bookeeping lead self transfer to increase balance | bad_self_transfer.sol
| 3 | transfer | transfers are broken because the receiver gets one extra token |bad_transfer_plus_one.sol 
| 4 | approve | Allowances, once set for a spender, cannot be updated | cannot_change_allowance.sol
| 5 | _mint | Total supply increases by one extra token | bad_total_supply.sol
| 6 | _burn | Total supply does not change on burns | bad_burn.sol
| 7 | transfer,transferFrom | Backdoor function allows to pause the contract | bad_backdoorPaused.sol
| 8 | transferFrom | Invert from and msg.sender on allowance | bad_transferFromAllowance.sol
| 9 | backdoor, mint | Backdoor allows to mint tokens | bad_mint1.sol
| 10 | backdoor, mint | Backdoor allows to mint burned tokens | bad_mint2.sol

## Self evaluation

To evaluate how many bugs were caught by your submission, you can run the `eval.sh` file:
```bash
sh eval.sh
```

**NOTE**: Please keep in mind that your `submission.sol` file must be in the `contracts/` directory and must look like this:
```solidity
pragma solidity 0.8.19;

import "./SignedWadMathTest.sol";
import "./FixedPointMathLibTest.sol";
import "./ERC20Test.sol";
import "./ERC20TestAdvanced.sol";
```

If your `submission.sol` does not look like this then the script will not work.

**NOTE**: If you are a Windows user, unfortunately, the above script will not work for you. You may either use a Linux VM or Windows Subsystem for Linux (WSL).

Each file (`FixedPointMathLib`, `SignedWadMath`, and `ERC20Burn`) has 10 bugs introduced to them. Thus, there are a total of 30 bugs. The bash script will individually test each bug to see whether your submission caught the bug. To see which bugs were introduced, you can check out the `bugs/` folder. The `bugs/` folder has three sub-directories where each sub-folder is related to one of the files. For example, the `bugs/erc/` folder holds the 10 bugs for the `ERC20Burn` contract.

The `eval.sh` script output will notify you if your submission caught on or more bugs. Here is an example output:
 ```
 Switched global version to 0.8.19
testing FixedPointMathLib bugs
 - bad_mulDivUp_one.sol was caught
 - bad_mulDivUp_two.sol was caught
 - bad_rpow.sol was caught
testing SignedWadMath bugs
 - bad_decimals.sol was caught
 - bad_wadExp.sol was caught
testing ERC20 bugs
 - bad_burn.sol was caught
 - bad_total_supply.sol was caught
```
 Based on the output above, your submission caught 3/10 bugs in the `FixedPointMathLib` library, 2/10 bugs in the `SignedWadMath` library, and 2/10 bugs in the `ERC20` burn contract. Note that there is a chance that you caught the bug for the **wrong reason**. Even though `medusa` hit an assertion failure when trying to catch the bug, it does not mean that it caught the bug that we introduced. The script will simply look for the string "assertion failed" in `medusa`'s output and nothing else. An assertion failure could, for example, also occur if the invariant is incorrectly written. To see whether you actually caught the bug, you must perform a manual review.

 To perform a manual review on whether you caught a bug and do not have a false positive, you can individually review the output from `medusa` for each bug that was introduced. The output of `medusa` is in the `contracts/results/` folder. The `results/` folder will hold 30 files where each file is related to one of the introduced bugs. You can then validate whether the output + the invariant you specified was sufficient in finding the bug. Note that we performed a brief manual review of your submissions and reduced the false positive rate to the best of our abilities. 

 If you have any questions, please reach out to the ToB team on Discord. 