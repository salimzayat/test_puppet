filebucket { 'main':
	server => 'master',
	path => false,
	
}

File { backup => 'main' }

Package {
	allow_virtual => false
}

node default {
	include profiles::notify_a_message
}

