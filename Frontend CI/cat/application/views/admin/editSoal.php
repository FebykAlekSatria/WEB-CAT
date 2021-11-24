<!-- Content Wrapper -->
<!-- Begin Page Content -->
<!-- Page Heading -->
<?php
$id = $this->input->get('id');
$kunci = $this->db->query("call get_kunci_jawaban('$id')")->result_array();
$jawaban = strtoupper($kunci[0]['kunci']);
// $temp1 = explode(" ", $temp);
// $jawaban = array(" ", " ", " ", " ", " ");
// for ($i = 0; $i < count($temp1); $i++) {
//     $jawaban[$i] = $temp1[$i];
// }
$this->db->reconnect();
$result = $this->db->query("call get_detail_soal('$id')")->result_array();
$this->db->reconnect();
$bobot = $this->db->query("call get_bobot_soal('$id')")->result_array();
$kategori = $result[0]['nama_kategori'];
$pertanyaan = $result[0]['pertanyaan'];
$gambar = $result[0]['gambar'];
$opsi_a = $result[0]['opsi_a'];
$opsi_b = $result[0]['opsi_b'];
$opsi_c = $result[0]['opsi_c'];
$opsi_d = $result[0]['opsi_d'];
$opsi_e = $result[0]['opsi_e'];
$bobot_a = $bobot[0]['opsi_a'];
$bobot_b = $bobot[0]['opsi_b'];
$bobot_c = $bobot[0]['opsi_c'];
$bobot_d = $bobot[0]['opsi_d'];
$bobot_e = $bobot[0]['opsi_e'];
?>
<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800 text-bold">Edit Soal</h1>
    <div class="card border-left-primary shadow mx-4">
        <div class="card-body">
            <div class="table-responsive">
                <form class="addSesi ml-auto" method="POST" action="<?= base_url('ImportController/edit_soal') ?>">
                    <div class="form-group">
                        <input type="hidden" id="id" name="id" value="<?= $id ?>">
                    </div>
                    <h3> Edit Soal</h3>
                    <?= $this->session->flashdata('message'); ?>
                    <div>
                        <label>Pilih Kategori</label>
                        <select class="custom-select" id="kategori" name="kategori">
                            <option selected>pilih kategori</option>
                            <?php
                            $no = 1;
                            $this->db->reconnect();
                            $result = $this->db->query('call get_kategori_list()');
                            foreach ($result->result_array() as $row) { ?>
                                <option value="<?= $row['nama_kategori'] ?>" <?= $kategori == $row['nama_kategori'] ? "selected='selected'" : ""; ?>><?= $row['nama_kategori'] ?></option>
                            <?php } ?>
                        </select>
                    </div><br />
                    <div>
                        <label>Isi Pertanyaan</label>
                        <textarea class="ckeditor" id="soal" name="soal"><?= $pertanyaan ?></textarea><br />
                    </div>
                    <div>
                        <label>Masukkan gambar</label>
                        <div class="form-row mx-auto">
                            <input class="form-control" type="file" id="foto" name="foto" />
                            <p class="text-primary">gambar akan selalu berada pada bagian atas soal</p>
                        </div><br />
                    </div>
                    <h3>jawaban</h3>
                    <div>
                        <label>Jawaban A</label>
                        <textarea class="ckeditor" id="opsi_a" name="opsi_a"><?= $opsi_a ?></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban A" name="bobot_a" value="<?= $bobot_a ?>"/>
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="A" <?php echo (strpos($jawaban, 'A') !== false ? 'checked' : ''); ?> />
                        </div><br />
                    </div>
                    <div>
                        <label>Jawaban B</label>
                        <textarea class="ckeditor" id="opsi_b" name="opsi_b"><?= $opsi_b ?></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban B" name="bobot_b" value="<?= $bobot_b ?>"/>
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="B" <?php echo (strpos($jawaban, 'B') !== false ? 'checked' : ''); ?> />
                        </div><br />
                    </div>
                    <div>
                        <label>Jawaban C</label>
                        <textarea class="ckeditor" id="opsi_c" name="opsi_c"><?= $opsi_c ?></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban C" name="bobot_c" value="<?= $bobot_c ?>"/>
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="C" <?php echo (strpos($jawaban, 'C') !== false ? 'checked' : ''); ?> />
                        </div><br />
                    </div>
                    <div>
                        <label>Jawaban D</label>
                        <textarea class="ckeditor" id="opsi_d" name="opsi_d"><?= $opsi_d ?></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban D" name="bobot_d" value="<?= $bobot_d ?>"/>
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="D" <?php echo (strpos($jawaban, 'D') !== false ? 'checked' : ''); ?> />
                        </div><br />
                    </div>
                    <div>
                        <label>Jawaban E</label>
                        <textarea class="ckeditor" id="opsi_e" name="opsi_e"><?= $opsi_e ?></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban E" name="bobot_e" value="<?= $bobot_e ?>"/>
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="E" <?php echo (strpos($jawaban, 'E') !== false ? 'checked' : ''); ?> />
                        </div><br />
                    </div>
                    <div class="modal-footer">
                        <a href="<?= base_url('admin/soal') ?>" type="botton" class="btn btn-secondary" data-dismiss="modal">batal</a>
                        <button type="submit" class="btn btn-primary">Simpan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- card soal -->
</div>
<!-- /.container-fluid -->
</div>
<!-- End of Main Content -->
</div>
<!-- End of Content Wrapper -->
</div>
<!-- End of Page Wrapper -->
<!-- Scroll to Top Button-->
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>
