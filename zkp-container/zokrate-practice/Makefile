include ../Makefile.mk

PROJECT_NAME=circom_practice

## Compile circom. | Run
compile:
	@if [ -f $(name).zok ]; then \
		rm -rf $(name)_zok_metadata; \
		mkdir $(name)_zok_metadata; \
		zokrates compile -i $(name).zok -s $(name)_zok_metadata/$(name)_api.json -o $(name)_zok_metadata/$(name)_out -r $(name)_zok_metadata/$(name).r1cs; \
	else \
		echo "$(name).circom does not exist"; \
	fi

## Trusted setup
setup:
	zokrates setup -i $(name)_zok_metadata/$(name)_out -p $(name)_zok_metadata/$(name)_proving.key -u $(name)_zok_metadata/$(name)_universal_setup.dat -v $(name)_zok_metadata/$(name)_verification.key

## Inspect
inspect:
	zokrates inspect -i $(name)_zok_metadata/$(name)_out

## Compute witness
witness:
	zokrates compute-witness -s $(name)_zok_metadata/$(name)_api.json --circom-witness $(name)_zok_metadata/$(name)_out.wtns -i $(name)_zok_metadata/$(name)_out -o $(name)_zok_metadata/$(name)_witness --json -a $(input)

## Generate proof
proof:
	zokrates generate-proof -i $(name)_zok_metadata/$(name)_out -j $(name)_zok_metadata/$(name)_proof.json -p $(name)_zok_metadata/$(name)_proving.key -w $(name)_zok_metadata/$(name)_witness

## Verify the proof, pretend you are a verifier, you can use this command to verify the proof
verify:
	zokrates verify -j $(name)_zok_metadata/$(name)_proof.json -v $(name)_zok_metadata/$(name)_verification.key

## Generate solidity smart contract
solidity:
	zokrates export-verifier -i $(name)_zok_metadata/$(name)_verification.key -o $(name)_zok_metadata/$(name).sol

## Clear.
clear:
	rm -rf *_zok_metadata
