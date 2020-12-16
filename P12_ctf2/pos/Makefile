.PHONY: mysql connect client clean

mysql:
	docker run --name myshop -e MYSQL_ROOT_PASSWORD=gwoieng23fjj \
	    -p 3306:3306 -d mysql:5.7

connect:
	docker exec -it myshop bash # then mysql -p

client:
	python myshop/myshop.py

barcode.svg:
	echo "1 UNION SELECT 1" | barcode -S -o barcode.svg

clean:
	docker stop myshop && docker rm myshop
