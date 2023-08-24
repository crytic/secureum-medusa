
# Secureum Medusa workshop

The goals of this workshop are to:
- Learn about invariants development
- Become familar with the medusa fuzzer

Medusa is a [new experimental fuzzer](https://github.com/crytic/medusa). Do not hesitate to ask questions on secureum's discord, or create [github issues](https://github.com/crytic/medusa/issues/new) if you encounter any issue.

## Before starting

To install medusa, follow [the installation instructions](https://github.com/crytic/medusa/#installation).

### Solc

Solc 0.8.19 is used for this workshop. We recommend [solc-select](https://github.com/crytic/solc-select) to easily switch between solc versions:
```
pip3 install solc-select
solc-select install 0.8.19
solc-select use 0.8.19
```

## The contest

The goals of the contest is to write invariants for three targets (`SignedWadMath`, `FixedPointMathLib`, `ERC20Burn`). All the contracts are inspired from [solmate](https://github.com/transmissions11/solmate).


### Helper
- [`helper`](./contracts/helper.sol) comes from the [properties](https://github.com/crytic/properties) repo, and contains helpers to ease the creation of invariants. In particular we recommend to use:
  - `asssertX` (`Eq`, `Neq`, `Gte`, `Gt`, `Lte`, `Lt`) to test assertion between values
  - `clampX` ( `Between`, `Lt`, `Lte`, `Gt`, `Gte` ) to restraint the inputs' values 

### SignedWadMath
- [`SignedWadMath`](./contracts/SignedWadMath.sol) is a signed 18 decimal fixed point (wad) arithmetic library.
- [`SignedWadMathTest`](./contracts/SignedWadMathTest.sol) is an example of test for `SignedWadMath` 
  - `testtoWadUnsafe` is an example of invariant to help you

### FixedPointMathLib
- [`FixedPointMathLib`](./contracts/FixedPointMathLib.sol) is an arithmetic library with operations for fixed-point numbers.
- [`FixedPointMathLibTest`](./contracts/FixedPointMathLibTest.sol) is an example of test for `SignedWadMath` 
  - `testmulDivDown` is an example of invariant to help you

### ERC20Burn
- [`ERC20`](./contracts/ERC20.sol) is a standard ERC20 token.
- [`ERC20Burn`](./contracts/ERC20Burn.sol) extends `ERC20`  with a burn function
- [`ERC20Test`](./contracts/ERC20Test.sol) is an example of test for `ERC20Burn` 
  - `fuzz_Supply` is an example of invariant to help you
- [`ERC20TestAdvanced`](./contracts/ERC20TestAdvanced.sol) is an example of an advanced test for `ERC20Burn` 
   - `ERC20TestAdvanced` uses the [external testing approach](https://secure-contracts.com/program-analysis/echidna/basic/common-testing-approaches.html#external-testing) and uses a proxy contract to simulate a user. This approach is more complex to use, but allows to test for more complex scenario
   - `testTransferFrom`  is an example of invariant to help you

### ERC20Burn


## How to start

A few pointers to start:

- Read the documentation
- Start small, and create simple invariants first
  -  Start with `SignedWadMath`
- Consider when operation should or it should not revert
- Some properties could require to use certain tolerance
-  `ERC20TestAdvanced` is recommended only for users that have already explored the other contracts
- Do not hesitate to introduce bugs in your code to verify that your invariants can catch them


To start a fuzzing campagn
```bash
medusa fuzz --target contracts/NAME.sol --deployment-order CONTRACT_NAME
```
Replace `NAME.sol` and `CONTRACT_NAME`.

## Expected Results and Evaluation

User should be able to fully test the contracts. It is worth mentioning that the code is unmodified and there are no known issues. If you find some security or correctness issue in the code do NOT post it in this repository nor upstream, since these are public messages. Instead, [contact us](mailto:josselin@trailofits.com) to confirm the issue and discuss how to proceed.

For Secureum, the resulting properties will be evaluated introducing an artificial bug in the code and running a short fuzzing campaign.

We encourage you to try different approaches and invariants. Invariants based development is a powerful tool for developer and auditors that require practices and experience to master it. 

## Self-Evaluation

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

## Configuration
[medusa.json](./medusa.json) was generated with `medusa init`. The following changes were applied:
- `testAllContracts` was set to true
- `corpusDirectory` was set to "corpus"
- `assertionTesting/enabled` was set to true

## Documentation
- [Medusa configuration](https://github.com/crytic/medusa/wiki/Project-Configuration)
- [Fuzzing workshop](https://www.youtube.com/watch?v=QofNQxW_K08&list=PLciHOL_J7Iwqdja9UH4ZzE8dP1IxtsBXI)
- [Fuzzing training](https://secure-contracts.com/program-analysis/echidna/index.html)
