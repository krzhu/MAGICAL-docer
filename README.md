Based on Mingjie Liu's Dockerfile

`` docker build . --file Dockerfile --tag magical:latest ``
``docker run -it -p 5800:5800 -v $(pwd):/MAGICAL magical:latest bash``
``jupyter notebook --ip 0.0.0.0 --no-browser --allow-root``

Then access in browser at `http://localhost:8888/tree`
