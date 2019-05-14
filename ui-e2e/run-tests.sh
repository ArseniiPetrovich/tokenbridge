#!/usr/bin/env bash
cd $(dirname $0)

docker-compose up -d --build --force-recreate
cd ../bridge-ui
npm run start:blocks &
cd ../ui-e2e
docker-compose run contracts ./deploy.sh
docker-compose run -d bridge npm run watcher:signature-request
docker-compose run -d bridge npm run watcher:collected-signatures
docker-compose run -d bridge npm run watcher:affirmation-request
docker-compose run -d bridge-erc20 npm run watcher:signature-request
docker-compose run -d bridge-erc20 npm run watcher:collected-signatures
docker-compose run -d bridge-erc20 npm run watcher:affirmation-request
docker-compose run -d bridge-erc20-native npm run watcher:signature-request
docker-compose run -d bridge-erc20-native npm run watcher:collected-signatures
docker-compose run -d bridge-erc20-native npm run watcher:affirmation-request
docker-compose run -d bridge npm run sender:home
docker-compose run -d bridge npm run sender:foreign
docker-compose run -d ui npm start
docker-compose run -d ui-erc20 npm start
docker-compose run -d ui-erc20-native npm start
cd ../bridge-ui
npm run startE2e
rc=$?
cd ../ui-e2e
ps | grep node | grep -v grep | awk '{print "kill " $1}' | sh
docker-compose down
exit $rc
