
default:
	cd jessie && docker build \
		--tag vevende/python3:latest \
		--cache-from vevende/python3:latest .

	docker push vevende/python3:latest
