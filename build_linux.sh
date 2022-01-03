git pull origin master;
docker run --rm -it -v $(pwd):/nasher urothis/nwnee-community-images:nasher-8193.34 pack --clean --verbose;
mv ../amia_server/test_server/modules/Amia.mod ../amia_server/test_server/modules/Amia.mod.bak;
cp Amia.mod ../amia_server/test_server/modules;