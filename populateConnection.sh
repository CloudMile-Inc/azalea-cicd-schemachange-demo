#!/bin/bash
# Script used in github actions to run test the schemachange functionality against the demo scenarios included in the repository.
touch ./connections.toml
echo [default] >> ./connections.toml
echo account = \"${SF_ACCOUNT}\" >> ./connections.toml
echo user = \"${SF_USERNAME}\" >> ./connections.toml
echo role = \"${SF_ROLE}\" >> ./connections.toml
echo warehouse = \"${SF_WAREHOUSE}\" >> ./connections.toml
echo database = \"${SF_DATABASE}\" >> ./connections.toml
echo password = \"${SF_PASSWORD}\" >> ./connections.toml
echo "cat connections.toml"
cat ./connections.toml