-- upsertBundle
INSERT INTO bundles (
  id, root_transaction_id, format_id,
  unbundle_filter_id, index_filter_id,
  data_item_count, matched_data_item_count,
  first_queued_at, last_queued_at,
  first_skipped_at, last_skipped_at,
  first_unbundled_at, last_unbundled_at,
  first_fully_indexed_at, last_fully_indexed_at
) VALUES (
  @id, @root_transaction_id, @format_id,
  @unbundle_filter_id, @index_filter_id,
  @data_item_count, @matched_data_item_count,
  @queued_at, @queued_at,
  @skipped_at, @skipped_at,
  @unbundled_at, @unbundled_at,
  @fully_indexed_at, @fully_indexed_at
) ON CONFLICT DO UPDATE SET
  data_item_count = IFNULL(@data_item_count, data_item_count),
  matched_data_item_count = IFNULL(@matched_data_item_count, matched_data_item_count),
  unbundle_filter_id = IFNULL(@unbundle_filter_id, unbundle_filter_id),
  index_filter_id = IFNULL(@index_filter_id, index_filter_id),
  first_queued_at = IFNULL(first_queued_at, @queued_at),
  last_queued_at = IFNULL(@queued_at, last_queued_at),
  first_skipped_at = IFNULL(first_skipped_at, @skipped_at),
  last_skipped_at = IFNULL(@skipped_at, last_skipped_at),
  first_unbundled_at = IFNULL(first_unbundled_at, @unbundled_at),
  last_unbundled_at = IFNULL(@unbundled_at, last_unbundled_at),
  first_fully_indexed_at = IFNULL(first_fully_indexed_at, @fully_indexed_at),
  last_fully_indexed_at = @fully_indexed_at

-- insertOrIgnoreWallet
INSERT INTO wallets (address, public_modulus)
VALUES (@address, @public_modulus)
ON CONFLICT DO NOTHING

-- insertOrIgnoreTagName
INSERT INTO tag_names (hash, name)
VALUES (@hash, @name)
ON CONFLICT DO NOTHING

-- insertOrIgnoreTagValue
INSERT INTO tag_values (hash, value)
VALUES (@hash, @value)
ON CONFLICT DO NOTHING

-- upsertNewDataItemTag
INSERT INTO new_data_item_tags (
  tag_name_hash, tag_value_hash,
  root_transaction_id, data_item_id, data_item_tag_index,
  height, indexed_at
) VALUES (
  @tag_name_hash, @tag_value_hash,
  @root_transaction_id, @data_item_id, @data_item_tag_index,
  @height, @indexed_at
) ON CONFLICT DO UPDATE SET height = IFNULL(@height, height)

-- upsertBundleDataItem
INSERT INTO bundle_data_items (
  id,
  parent_id,
  parent_index,
  filter_id,
  root_transaction_id,
  first_indexed_at,
  last_indexed_at
) VALUES (
  @id,
  @parent_id,
  @parent_index,
  @filter_id,
  @root_transaction_id,
  @indexed_at,
  @indexed_at
) ON CONFLICT DO
UPDATE SET
  filter_id = IFNULL(@filter_id, filter_id),
  last_indexed_at = @indexed_at

-- upsertNewDataItem
INSERT INTO new_data_items (
  id, parent_id, root_transaction_id, height, signature, anchor,
  owner_address, target, data_offset, data_size, content_type,
  tag_count, indexed_at
) VALUES (
  @id, @parent_id, @root_transaction_id, @height, @signature, @anchor,
  @owner_address, @target, @data_offset, @data_size, @content_type,
  @tag_count, @indexed_at
) ON CONFLICT DO UPDATE SET height = IFNULL(@height, height)
