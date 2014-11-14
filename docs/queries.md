500px example queries
=====================

Authentication
--------------

For the purpose of anonymous read only access the consumer key
``AVN1T2dh0PbZffBoLsQHlqToFUUUfptMhVM5whV8`` will be used.

Obtain list of thumbnails
-------------------------

Prototype:

[https://api.500px.com/v1/photos?feature=popular&sort=rating&image_size=2&page=1rpp=20](https://api.500px.com/v1/photos?feature=popular&sort=rating&image_size=2&page=1rpp=20&consumer_key=AVN1T2dh0PbZffBoLsQHlqToFUUUfptMhVM5whV8)

[Reference](https://github.com/500px/api-documentation/blob/master/endpoints/photo/GET_photos.md).
The available sizes for the images are:

* [1 70px](https://gp1.wac.edgecastcdn.net/806614/photos/photos.500px.net/89305411/e12531201093b619692261025a5ad69f6a8b1934/1.jpg?v=6).
* [2 140px](https://gp1.wac.edgecastcdn.net/806614/photos/photos.500px.net/89305411/e12531201093b619692261025a5ad69f6a8b1934/2.jpg?v=6).
* [3 280px](https://gp1.wac.edgecastcdn.net/806614/photos/photos.500px.net/89305411/e12531201093b619692261025a5ad69f6a8b1934/3.jpg?v=6).
* [4 fullpx](https://gp1.wac.edgecastcdn.net/806614/photos/photos.500px.net/89305411/e12531201093b619692261025a5ad69f6a8b1934/4.jpg?v=6).

With regards to the iphone app, 70px fits neatly in a 320px with screen with
some spacing, so we can use number 2 due to screens being retina.

The ``rpp`` parameter forces a specific page result set. 20 looks good. Page
numbering starts with 1.
