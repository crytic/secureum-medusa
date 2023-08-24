solc-select use 0.8.19

echo "testing FixedPointMathLib bugs"

cd contracts/
mkdir -p results

for bug in $(ls ../bugs/fixed) ; do
    # echo "Testing $bug with $user properties"
    cp ../bugs/fixed/$bug FixedPointMathLib.sol
    cp ../bugs/ERC20Burn.sol ERC20Burn.sol
    cp ../bugs/SignedWadMath.sol SignedWadMath.sol
    rm -Rf corpus
    medusa fuzz --target contracts/submission.sol --deployment-order FixedPointMathLibTest --seq-len 1 --test-limit 100000 --config ../medusa.json > tmp.out
    perl -pe 's/\x1b\[[0-9;]*[mG]//g' tmp.out > results/$bug.out
    rm tmp.out

    bug_count=$(grep -c 'assertion failed' results/$bug.out)

    if [[ $bug_count -ne 0 ]]; then
        echo " - $bug was caught"
    fi
done

echo "testing SignedWadMath bugs"

for bug in $(ls ../bugs/signed) ; do
    #echo "Testing $bug with $user properties"	
    cp ../bugs/signed/$bug SignedWadMath.sol
    cp ../bugs/ERC20Burn.sol ERC20Burn.sol
    cp ../bugs/FixedPointMathLib.sol FixedPointMathLib.sol
    rm -Rf corpus
    medusa fuzz --target contracts/submission.sol --deployment-order SignedWadMathTest --seq-len 1 --test-limit 100000 --config ../medusa.json > tmp.out
    perl -pe 's/\x1b\[[0-9;]*[mG]//g' tmp.out > results/$bug.out
    rm tmp.out

    bug_count=$(grep -c 'assertion failed' results/$bug.out)

    if [[ $bug_count -ne 0 ]]; then
        echo " - $bug was caught"
    fi

done

echo "testing ERC20 bugs"

for bug in $(ls ../bugs/erc) ; do
    #echo "Testing $bug with $user properties"	
    cp ../bugs/erc/$bug ERC20Burn.sol
    cp ../bugs/SignedWadMath.sol SignedWadMath.sol
    cp ../bugs/FixedPointMathLib.sol FixedPointMathLib.sol
    rm -Rf corpus
    medusa fuzz --target contracts/submission.sol --deployment-order MyToken,ExternalTestingToken --seq-len 10 --test-limit 100000 --config ../medusa.json > tmp.out
    perl -pe 's/\x1b\[[0-9;]*[mG]//g' tmp.out > results/$bug.out
    rm tmp.out

    bug_count=$(grep -c 'assertion failed' results/$bug.out)

    if [[ $bug_count -ne 0 ]]; then
        echo " - $bug was caught"
    fi

done