class CreateCsvTables < ActiveRecord::Migration[6.0]
  def up
    execute(%{
      create sequence csv_files_id_seq;
      create table csv_files (
        id integer not null
          default nextval('csv_files_id_seq'),
        identifier varchar(256) not null unique
          check(length(identifier) > 1),
        primary key(id)
      );
      create sequence processed_csvs_id_seq;
      create table processed_csvs (
        id integer not null
          default nextval('processed_csvs_id_seq'),
        first varchar(256)
          check(length(first) > 1),
        last varchar(256)
          check(length(last) > 1),
        email varchar(256),
        phone varchar(10),
        row_number integer not null,
        identifier varchar(256) not null,
        primary key (id),
        unique(row_number, identifier)
      );
      create index processed_csvs_id_idx on processed_csvs(id);
      create sequence csv_errors_id_seq;
      create table csv_errors(
        id integer not null
          default nextval('csv_errors_id_seq'),
        row_number integer not null,
        identifier varchar(256) not null,
        row_errors text[],
        primary key (id),
        unique(row_number, identifier)
      );
    })
  end

  def down
    execute(%{
      drop index if exists processed_csvs_id_idx;
      drop table if exists csv_files;
      drop table if exists csv_errors;
      drop table if exists processed_csvs;
      drop sequence if exists processed_csvs_id_seq;
      drop sequence if exists csv_files_id_seq;
      drop sequence if exists csv_errors_id_seq;
    })
  end
end
