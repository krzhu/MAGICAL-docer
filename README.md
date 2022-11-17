Based on Mingjie Liu's Dockerfile

To access jupyter notebook:
`` docker build . --file Dockerfile --tag magical:latest ``

``docker run -it -p 8888:8888 -v $(pwd):/MAGICAL magical:latest bash``

``jupyter notebook --ip 0.0.0.0 --no-browser --allow-root``

Then access in browser at `http://localhost:8888/tree`


This branch is for Skywater 130nm
