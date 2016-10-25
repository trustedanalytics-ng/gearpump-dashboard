#
# Copyright (c) 2016 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

############################ GEARPUMP DASHBOARD #############################
#TODO: verify whether package exsists - then exit

VERSION=0.8.1

# download gearpump binaries
GEARPUMP_PACK_FULL_VER=$(cat src/cloudfoundry/manifest.yml | grep GEARPUMP_PACK_VERSION | cut -d ' ' -f 6- | sed 's/["]//g')
GEARPUMP_PACK_SHORT_VER=$(echo $GEARPUMP_PACK_FULL_VER | cut -d '-' -f 2-)
GEARPUMP_FOLDER=gearpump-$GEARPUMP_PACK_FULL_VER
GEARPUMP_FILE_ZIP=$GEARPUMP_FOLDER.zip

if [ -e $GEARPUMP_FILE_ZIP ] ; then
    echo "Package $GEARPUMP_FILE_ZIP already downloaded."
else
    echo "Downloading $GEARPUMP_FILE_ZIP..."
    curl --location --retry 3 --insecure https://github.com/gearpump/gearpump/releases/download/$GEARPUMP_PACK_SHORT_VER/$GEARPUMP_FILE_ZIP -o $GEARPUMP_FILE_ZIP
fi


TMP_CATALOG=/tmp/gearpump-binaries

rm -rf $TMP_CATALOG
mkdir -p $TMP_CATALOG

unzip $GEARPUMP_FILE_ZIP -d $TMP_CATALOG

cd scripts
./prepare.sh $TMP_CATALOG/$GEARPUMP_FOLDER $TMP_CATALOG

cd ..

# prepare files to archive
mkdir -p target
mv $TMP_CATALOG/target/gearpump-dashboard.tar.gz target/gearpump-dashboard-${VERSION}.tar.gz
echo "commit_sha=$(git rev-parse HEAD)" > build_info.ini

# clean temporary data
rm -r $TMP_CATALOG

echo "tar.gz package for gearpump-dashboard project in version $VERSION has been prepared."
