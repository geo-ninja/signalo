-- Table: signalo_od.frame

-- DROP TABLE signalo_od.frame;

CREATE TABLE signalo_od.frame
(
    id uuid PRIMARY KEY default uuid_generate_v1(),
    fk_azimut uuid not null,
    rank int default 1 not null, -- TODO: get default
    fk_frame_type int,
    fk_frame_fixing_type int,
    double_sided boolean default true,
    fk_status int,
    fk_provider uuid,
    comment text,
    picture text,
    dimension_1 decimal(7,2),
    dimension_2 decimal(7,2),
    _inserted_date timestamp default now(),
    _inserted_user text,
    _last_modified_date timestamp default now(),
    _last_modified_user text,
    _edited boolean default false,
    CONSTRAINT fkey_od_azimut FOREIGN KEY (fk_azimut) REFERENCES signalo_od.azimut (id) MATCH FULL  DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fkey_vl_frame_type FOREIGN KEY (fk_frame_type) REFERENCES signalo_vl.frame_type (id) MATCH FULL,
    CONSTRAINT fkey_vl_status FOREIGN KEY (fk_status) REFERENCES signalo_vl.status (id) MATCH FULL,
    CONSTRAINT fkey_vl_frame_fixing_type FOREIGN KEY (fk_frame_fixing_type) REFERENCES signalo_vl.frame_fixing_type (id) MATCH FULL,
    CONSTRAINT fkey_od_provider FOREIGN KEY (fk_provider) REFERENCES signalo_od.provider (id) MATCH FULL,
    UNIQUE (fk_azimut, rank) DEFERRABLE INITIALLY DEFERRED
);

-- reorder frames after deletion or azimut change
CREATE OR REPLACE FUNCTION signalo_od.ft_reorder_frames_on_support() RETURNS TRIGGER AS
	$BODY$
	DECLARE
	    _rank integer := 1;
	    _frame record;
	BEGIN
        FOR _frame IN (SELECT * FROM signalo_od.frame WHERE fk_azimut = OLD.fk_azimut ORDER BY rank ASC)
        LOOP
            UPDATE signalo_od.frame SET rank = _rank WHERE id = _frame.id;
            _rank = _rank + 1;
        END LOOP;
		RETURN OLD;
	END;
	$BODY$
	LANGUAGE plpgsql;

-- on delete
CREATE TRIGGER tr_frame_on_delete_reorder
	AFTER DELETE ON signalo_od.frame
	FOR EACH ROW
	EXECUTE PROCEDURE signalo_od.ft_reorder_frames_on_support();
COMMENT ON TRIGGER tr_frame_on_delete_reorder ON signalo_od.frame IS 'Trigger: update frames order after deleting one.';

-- before changing azimut, update rank to be the last on the new azimut
CREATE OR REPLACE FUNCTION signalo_od.ft_reorder_frames_on_support_put_last() RETURNS TRIGGER AS
	$BODY$
	BEGIN
	    NEW.rank := (SELECT MAX(rank)+1 FROM signalo_od.frame WHERE fk_azimut = NEW.fk_azimut);
		RETURN NEW;
	END;
	$BODY$
	LANGUAGE plpgsql;

CREATE TRIGGER tr_frame_on_update_azimut_reorder_prepare
	BEFORE UPDATE OF fk_azimut ON signalo_od.frame
	FOR EACH ROW
	WHEN (OLD.fk_azimut <> NEW.fk_azimut)
	EXECUTE PROCEDURE signalo_od.ft_reorder_frames_on_support_put_last();
COMMENT ON TRIGGER tr_frame_on_update_azimut_reorder_prepare ON signalo_od.frame IS 'Trigger: after changing azimut, adapt rank be last on new azimut';

-- after changing azimut, update frame ranks on old azimut
CREATE TRIGGER tr_frame_on_update_azimut_reorder
	AFTER UPDATE OF fk_azimut ON signalo_od.frame
	FOR EACH ROW
	WHEN (OLD.fk_azimut <> NEW.fk_azimut)
	EXECUTE PROCEDURE signalo_od.ft_reorder_frames_on_support();
COMMENT ON TRIGGER tr_frame_on_update_azimut_reorder ON signalo_od.frame IS 'Trigger: update frames order after changing azimut.';

