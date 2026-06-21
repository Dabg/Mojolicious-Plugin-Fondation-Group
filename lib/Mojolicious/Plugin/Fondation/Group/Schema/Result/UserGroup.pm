package Mojolicious::Plugin::Fondation::Group::Schema::Result::UserGroup;

# ABSTRACT: DBIx::Class Result class for user_group pivot table

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/TimeStamp Core/);

__PACKAGE__->table('user_group');

__PACKAGE__->add_columns(
    id       => { data_type => 'integer', is_auto_increment => 1, is_nullable => 0 },
    user_id  => { data_type => 'integer', is_nullable => 0 },
    group_id => { data_type => 'integer', is_nullable => 0 },

    created_at => { data_type => 'datetime', is_nullable => 0, set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    'group',
    'Mojolicious::Plugin::Fondation::Group::Schema::Result::Group',
    'group_id',
);

1;
