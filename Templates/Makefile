help:
	@echo "Run 'install-xcode-template' to install the Clean Architecture feature template"

install-xcode-template:
	mkdir -p ~/Library/Developer/Xcode/Templates/File\ Templates/Custom
	rsync -vaE --delete --progress Feature.xctemplate ~/Library/Developer/Xcode/Templates/File\ Templates/Custom
	@echo "**Xcode template updated! See 'Custom > Feature' when creating a new file.**"
