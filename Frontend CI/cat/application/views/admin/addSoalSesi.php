<!-- Begin Page Content -->
<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800 text-bold">Tambah Soal Sesi</h1>
    <div class="card border-left-primary shadow mx-4">
        <div class="card-body">
            <div class="table-responsive">
                <?= $this->session->flashdata('message'); ?>
                <form method="POST" action="<?= base_url('ImportController/pilih_soal'); ?>">
                    <table class="table table-sm table-striped text-center" id="score">
                        <thead>
                            <tr>
                                <th class="col-md-1" scope="col">No</th>
                                <th class="col-md-3" scope="col">kategori</th>
                                <th class="col-md-3" scope="col">Jumlah soal</th>
                                <th class="col-md-3" scope="col">urutan soal</th>
                                <th>
                                    Aksi
                                    <input type="checkbox" value="" id="checked-all">
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            $id_s = $this->input->get('id');
                            $no = 1;
                            $check_jumlah = $this->db->query("call get_jumlah_soal_list('$id_s')");
                            $jumlah_s = array();
                            $urutan_s = array();
                            $idx = 0;
                            foreach ($check_jumlah->result_array() as $variable) {
                                $jumlah_s[$idx] = $variable['jumlah_soal'];
                                $urutan_s[$idx] = $variable['urutan'];
                                $jumlah_s[$variable['kategori_id']] = $jumlah_s[$idx];
                                unset($jumlah_s[$idx]);
                                $urutan_s[$variable['kategori_id']] = $urutan_s[$idx];
                                unset($urutan_s[$idx]);
                                $idx++;
                            }
                            $this->db->reconnect();
                            $result = $this->db->query('call get_kategori_list()');
                            $this->db->reconnect();
                            $jumlah = $check_jumlah->num_rows();
                            $id_k = array();
                            for ($k = 0; $k < $jumlah; $k++) {
                                $id_k[$k] = " ";
                            }
                            $i = 0;
                            foreach ($check_jumlah->result_array() as $value) {
                                $id_k[$i] = $value['kategori_id'];
                                $i++;
                            }
                            foreach ($result->result_array() as $row) { ?>
                                <tr>
                                    <th scope="row"><?= $no ?></th>
                                    <td><?= $row['nama_kategori'] ?></td>
                                    <input type="hidden" value="<?= $id_s ?>" id="id_sesi" name="id_sesi">
                                    <input type="hidden" value="<?= $row['nama_kategori'] ?>" id="nama_k" name="nama_k[]">
                                    <td class="row">
                                        <?php
                                        $check = 0;
                                        foreach ($id_k as $value1) {
                                            if ($row['id'] == $value1) {
                                                $check = 1;
                                                break;
                                            }
                                        }
                                        if ($check == 1) {
                                        ?>
                                            <div class="col-6">
                                                <input type="number" class="form-control" id="jumlah" name="jumlah[]" placeholder="jumlah soal" value="<?= $jumlah_s[$value1] ?>">
                                            </div>
                                        <?php
                                        } else {
                                        ?>
                                            <div class="col-6">
                                                <input type="number" class="form-control" id="jumlah" name="jumlah[]" placeholder="jumlah soal">
                                            </div>
                                        <?php
                                        }
                                        ?>
                                        <div>
                                            <?php
                                            $id_kategori = $row['id'];
                                            $this->db->reconnect();
                                            $bank_soal = $this->db->query("call get_maksimal_soal_by_kategori('$id_kategori')")->result_array();
                                            ?>
                                            <p>Maks : <?= $bank_soal[0]['maksimal_soal'] ?></p>
                                        </div>

                                    </td>
                                    <td>
                                        <?php
                                        $check = 0;
                                        foreach ($id_k as $value1) {
                                            if ($row['id'] == $value1) {
                                                $check = 1;
                                                break;
                                            }
                                        }
                                        if ($check == 1) {
                                        ?>
                                            <input type="number" class="form-control" id="urutan[]" name="urutan[]" placeholder="urutan soal" value="<?= $urutan_s[$value1] ?>">
                                        <?php
                                        } else {
                                        ?>
                                            <input type="number" class="form-control" id="urutan[]" name="urutan[]" placeholder="urutan soal">
                                        <?php
                                        }
                                        ?>
                                    </td>
                                    <td>
                                        <?php
                                        $check = 0;
                                        foreach ($id_k as $value1) {
                                            if ($row['id'] == $value1) {
                                                $check = 1;
                                                break;
                                            }
                                        }
                                        if ($check == 1) {
                                        ?>
                                            <input class="form-check-input" type="checkbox" value="<?= $row['id'] ?>" id="pilih" name="pilihSoal[]" <?php echo ($value1 == $row['id'] ? 'checked' : ''); ?>>
                                        <?php
                                        } else {
                                        ?>
                                            <input class="form-check-input" type="checkbox" value="<?= $row['id'] ?>" id="pilih" name="pilihSoal[]">
                                        <?php
                                        }
                                        ?>
                                        <?php

                                        ?>
                                        <a href="<?= base_url('ImportController/delete_soal_from_sesi') ?>?id=<?= $id_s . $row['id'] ?>"><i class="fas fa-undo-alt text-primary"></i></i></a>
                                    </td>
                                </tr>
                            <?php
                                $no++;
                            } ?>
                        </tbody>
                    </table>
                    <div class="modal-footer">
                        <a type="button" class="btn btn-secondary" data-dismiss="modal" href="<?= base_url('admin/jadwal') ?>">Batal</a>
                        <a type="button" class="btn btn-primary" data-toggle="modal" data-target="#addsoal">Simpan</a>
                        <div class="modal fade" id="addsoal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="exampleModalLongTitle">Tambah Peserta</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <di class="modal-body">
                                        <div>
                                            <h6>Pastikan Kategori yang dipilih tercentang</h6>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Kembali</button>
                                            <button type="submit" class="btn btn-primary">Simpan</button>
                                        </div>
                                    </di>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- card soal -->
</div>
<footer class="sticky-footer bg-white">
    <div class="container my-auto">
        <div class="copyright text-center my-auto">
            <span>Copyright &copy;Website 2021</span>
        </div>
    </div>
</footer>
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

<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
<script>
    $('#checked-all').on('change', function(e) {
        e.preventDefault()
        $('input[id=pilih]').prop('checked', this.checked)
    });
    $('#Jumlah').on('change', function(e) {
        e.preventDefault()
        $('input[id=pilih]').prop('checked', this.checked)
    });
</script>
