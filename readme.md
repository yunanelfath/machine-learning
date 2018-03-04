## How to install
#on windows
  - download supporting files

## Frequently problem
  - node-sass failed to install
      # npm cache clean or npm cache verify https://github.com/sass/node-sass/issues/1888
  - microsoft visual studio path not correctly
      # set VCTargetsPath on environment variable path, fill with "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\VC\VCTargets"
      # npm config get msvs_version -> to get current version
      # npm config set msvs_version=$current_visual_studio
  - npm install
