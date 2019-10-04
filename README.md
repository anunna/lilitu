# lilitu

Ebuild for Gentoo.

## HOWTO  

Create the required directory:
    
    # mkdir -p /usr/local/lilitu
    # mkdir -p /etc/portage/repos.conf

Download the lilitu.conf: 

    # wget -P /etc/portage/repos.conf/ https://raw.githubusercontent.com/AliaSiddique/lilitu/master/lilitu.conf

## Sync it.

    # emaint sync --repo lilitu

## Troubleshooting

If you found a package that doesn't work, please, post an issue.
