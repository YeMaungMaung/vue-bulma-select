.PHONY: deploy-site

deploy-site:
	git subtree push --prefix dist origin gh-pages
