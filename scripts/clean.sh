#!/bin/zsh

# Function to remove or back up Neovim caches
manage_nvim_cache() {
	local nvim_cache_dir="$HOME/.local/share/nvim"
	local nvim_cache_backup_dir="$HOME/.local/share/nvim.bak"

	if [ -d "$nvim_cache_dir" ]; then
		echo "$nvim_cache_dir exists."
		while true; do
			echo "Do you want to back up and delete the Neovim cache directory? (y/n): "
			read yn
			case $yn in
			[Yy]*)
				echo "Backing up Neovim cache directory..."
				mv "$nvim_cache_dir" "$nvim_cache_backup_dir"
				if [ $? -eq 0 ]; then
					echo "Neovim cache directory has been backed up to $nvim_cache_backup_dir and deleted from $nvim_cache_dir."
				else
					echo "Failed to back up and delete Neovim cache directory."
				fi
				break
				;;
			[Nn]*)
				echo "Skipped managing Neovim cache directory."
				return
				;;
			*)
				echo "Please answer yes or no."
				;;
			esac
		done
	else
		echo "Neovim cache directory does not exist. Nothing to do."
	fi
}

# Execute the function
manage_nvim_cache
