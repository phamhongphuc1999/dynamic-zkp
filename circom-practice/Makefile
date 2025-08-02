PROJECT_NAME=circom_practice

# colors
GREEN = $(shell tput -Txterm setaf 2)
YELLOW = $(shell tput -Txterm setaf 3)
WHITE = $(shell tput -Txterm setaf 7)
RESET = $(shell tput -Txterm sgr0)
GRAY = $(shell tput -Txterm setaf 6)
TARGET_MAX_CHAR_NUM = 20

## Compile circom. | Run
compile:
	@if [ -f $(name).circom ]; then \
		rm -rf $(name)_circom_metadata; \
		mkdir $(name)_circom_metadata; \
		circom $(name).circom --r1cs --wasm --sym --output $(name)_circom_metadata; \
	else \
		echo "$(name).circom does not exist"; \
	fi

## Inspect circom information
inspect:
	snarkjs r1cs info $(name)_circom_metadata/$(name).r1cs

## Compute witness
witness:
	node $(name)_circom_metadata/$(name)_js/generate_witness.js $(name)_circom_metadata/$(name)_js/$(name).wasm inputs/$(name)_input.json $(name)_circom_metadata/$(name)_witness.wtns

## Trusted setup, calculate common reference string
setup:
	snarkjs powersoftau new bn128 $(power) $(name)_circom_metadata/$(name).ptau -v
	snarkjs powersoftau contribute $(name)_circom_metadata/$(name).ptau $(name)_circom_metadata/$(name)1.ptau --name="First contribution" -v
	snarkjs powersoftau prepare phase2 $(name)_circom_metadata/$(name)1.ptau $(name)_circom_metadata/$(name)_final.ptau -v
	snarkjs groth16 setup $(name)_circom_metadata/$(name).r1cs $(name)_circom_metadata/$(name)_final.ptau $(name)_circom_metadata/$(name).zkey
	snarkjs zkey contribute $(name)_circom_metadata/$(name).zkey $(name)_circom_metadata/$(name)1.zkey --name="1st Contributor Name" -v
	snarkjs zkey export verificationkey $(name)_circom_metadata/$(name)1.zkey $(name)_circom_metadata/$(name)_verification_key.json

## Generate proof
proof:
	snarkjs groth16 prove $(name)_circom_metadata/$(name)1.zkey $(name)_circom_metadata/$(name)_witness.wtns $(name)_circom_metadata/$(name)_proof.json $(name)_circom_metadata/$(name)_public.json

## Verify the proof, pretend you are a verifier, you can use this command to verify the proof
verify:
	snarkjs groth16 verify $(name)_circom_metadata/$(name)_verification_key.json $(name)_circom_metadata/$(name)_public.json $(name)_circom_metadata/$(name)_proof.json

# Generate solidity smart contract
solidity:
	snarkjs zkey export solidityverifier $(name)_circom_metadata/$(name)1.zkey $(name)_circom_metadata/${name}.sol

## Clear.
clear:
	rm -rf *_circom_metadata

## Shows help. | Help
help:
	@echo ''
	@echo 'Usage:'
	@echo ''
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
				if (index(lastLine, "|") != 0) { \
				stage = substr(lastLine, index(lastLine, "|") + 1); \
				printf "\n ${GRAY}%s: \n\n", stage;  \
			} \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			if (index(lastLine, "|") != 0) { \
				helpMessage = substr(helpMessage, 0, index(helpMessage, "|")-1); \
			} \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''

