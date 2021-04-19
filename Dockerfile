FROM httpd:2.4
#First: where from your machine. Second: where on the container.
COPY ./html/ /usr/local/apache2/htdocs/
