<!-- Content Wrapper -->
<!-- Begin Page Content -->
<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800 text-bold">Tambah Soal</h1>
    <div class="card border-left-primary shadow mx-4">
        <div class="card-body">
            <div class="table-responsive">
                <form class="addSesi ml-auto" enctype="multipart/form-data" method="POST" action="<?= base_url('ImportController/add_soal') ?>">
                    <h3>Soal</h3>
                    <?= $this->session->flashdata('message'); ?>
                    <div>
                        <label>Pilih kategori</label>
                        <select class="custom-select" id="kategori" name="kategori">
                            <option>pilih kategori</option>
                            <?php
                            $no = 1;
                            $result = $this->db->query('call get_kategori_list()');
                            foreach ($result->result_array() as $row) { ?>
                                <option value="<?= $row['nama_kategori'] ?>"><?= $row['nama_kategori'] ?></option>
                            <?php } ?>
                        </select>
                    </div><br />
                    <div>
                        <label>Isi Pertanyaan</label>
                        <textarea class="ckeditor" id="soal" name="soal"></textarea>
                        <br />
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
                        <textarea class="ckeditor" id="opsi_a" name="opsi_a"></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban A" id="nilai a" name="bobot_a" />
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="A" />
                        </div><br />
                    </div>
                    <div>
                        <label>Jawaban B</label>
                        <textarea class="ckeditor" id="opsi_b" name="opsi_b"></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban B" id="nilai b" name="bobot_b" />
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="B" />
                        </div><br />
                    </div>
                    <div>
                        <label>Jawaban C</label>
                        <textarea class="ckeditor" id="opsi_c" name="opsi_c"></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban C" id="nilai c" name="bobot_c" />
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="C" />
                        </div><br />
                    </div>
                    <div>
                        <label>Jawaban D</label>
                        <textarea class="ckeditor" id="opsi_d" name="opsi_d"></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban D" id="nilai d" name="bobot_d" />
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="D" />
                        </div><br />
                    </div>
                    <div>
                        <label>Jawaban E</label>
                        <textarea class="ckeditor" id="opsi_e" name="opsi_e"></textarea>
                        <div class="form-row mx-auto">
                            <input class="form-control" placeholder="nilai jawaban E" id="nilai e" name="bobot_e" />
                            <p class="text-primary pr-4">centang jika jawaban ini benar</p>
                            <input class="mt-1" type="checkbox" id="jawaban" name="jawaban[]" value="E" />
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