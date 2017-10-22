galaxy_roles: requirements.yml
	ansible-galaxy install -r $< --roles-path=$@
