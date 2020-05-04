[![Codacy Badge](https://api.codacy.com/project/badge/Grade/58bf1ad350614a95935cdeef9d96f655)](https://www.codacy.com/manual/AliaSiddique/lilitu?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=AliaSiddique/lilitu&amp;utm_campaign=Badge_Grade)

# lilitu

Ebuild for Gentoo.

## HOWTO  

Create the required directory:
    
    # mkdir -p /usr/local/lilitu
    # mkdir -p /etc/portage/repos.conf

Download the lilitu.conf: 

    # wget -P /etc/portage/repos.conf/ https://raw.githubusercontent.com/anunna/lilitu/master/lilitu.conf

## Sync it

    # emaint sync --repo lilitu

## Troubleshooting

If you found a package that doesn't work, please, post an issue.
