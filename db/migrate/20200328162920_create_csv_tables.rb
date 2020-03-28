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
        primary key (id)
      );
      create index processed_csvs_id_idx on processed_csvs(id);
    })
  end

  def down
    execute(%{
      drop table csv_files;
      drop table processed_csvs;
      drop sequence processed_csvs_id_seq;
      drop sequence csv_files_id_seq;
      drop index processed_csvs_id_idx;
    })
  end
end
