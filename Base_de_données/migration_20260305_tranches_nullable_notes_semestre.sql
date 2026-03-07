-- Migration: Fix tranches_paiement.inscription_id nullable + add notes.semestre
-- Date: 2026-03-05

-- 1) tranches_paiement.inscription_id must allow NULL (écolage tranches)
ALTER TABLE tranches_paiement
  MODIFY COLUMN inscription_id BIGINT NULL;

-- 2) notes: add semestre (S1/S2)
ALTER TABLE notes
  ADD COLUMN semestre ENUM('S1','S2') NULL;

-- Backfill existing rows (default S1)
UPDATE notes
  SET semestre = 'S1'
  WHERE semestre IS NULL;

-- Make it NOT NULL after backfill
ALTER TABLE notes
  MODIFY COLUMN semestre ENUM('S1','S2') NOT NULL;
