package Mojolicious::Plugin::Fondation::Group;
use Mojo::Base 'Mojolicious::Plugin', -signatures;
use DBIx::Class::Relationship::ManyToMany::Async;

# ABSTRACT: Group management plugin for Fondation

our $VERSION = '0.01';

sub fondation_meta {
    return {
        dependencies => [
            'Fondation::Model::DBIx::Async',
            ],
        defaults => {
            title           => 'Group Management',
            openapi_exclude => ['UserGroup'],
            models          => {
                group => {
                    source  => 'Group',
                    backend => undef,  # must be set in app config
                },
                user_group => {
                    source  => 'UserGroup',
                    backend => undef,  # must be set in app config
                },
            },
        },
    };
}

sub register ($self, $app, $conf) {
    return $self;
}

sub fondation_finalyze ($self, $app, $long_name) {
    my $registry = $app->fondation->registry;

    # Only establish user↔group relation if User plugin is loaded
    if ($registry->{'Mojolicious::Plugin::Fondation::User'}) {
        many_to_many_async('Mojolicious::Plugin::Fondation::User::Schema::Result::User', 'groups', 'user_group', 'group');
        many_to_many_async('Mojolicious::Plugin::Fondation::Group::Schema::Result::Group', 'users',  'user_group', 'user');
    }

    # Only establish group↔perm relation if Perm plugin is loaded
    if ($registry->{'Mojolicious::Plugin::Fondation::Perm'}) {
        many_to_many_async('Mojolicious::Plugin::Fondation::Perm::Schema::Result::Perm',  'groups', 'group_perm', 'group');
        many_to_many_async('Mojolicious::Plugin::Fondation::Group::Schema::Result::Group', 'perms',  'group_perm', 'perm');
    }

    return 1;
}

1;
