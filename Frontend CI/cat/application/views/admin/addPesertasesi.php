<!-- Content Wrapper -->
<!-- modal add peserta-->
<?php
$id = $this->input->get('id');
$peserta_id = $this->db->query("call get_peserta_ujian_list_by_sesi('$id')")->result_array();
?>
<div class="modal fade" id="addUser" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Tambah Peserta</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form class="addPeserta" method="POST" action="<?= base_url('ImportController/add_peserta_sesi'); ?>">
                    <div class=" form-group">
                        <label>Nama Lengkap</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" placeholder="nama lengkap peserta">
                    </div>
                    <div class=" form-group">
                        <label>Username</label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="username peserta">
                    </div>
                    <div class="form-group">
                        <label>No Handphone</label>
                        <input type="number" autocomplete="off" class="form-control" id="noHandphone" name="noHandphone" placeholder="no hanphone">
                    </div>
                    <div class="form-group">
                        <label>Asal Sekolah</label>
                        <input type="text" class="form-control" id="asal" name="asal" placeholder="asal sekolah">
                    </div>
                    <div class="form-group">
                        <label>password</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="masukkan password">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">batal</button>
                        <button type="submit" class="btn btn-primary">Simpan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Begin Page Content -->
<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800 text-bold">Tambah peserta sesi</h1>
    <div class="card border-left-primary shadow mx-4">
        <div class="card-body">
            <div class="table-responsive">
                <div class="form-group col-md-10">
                    <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#addUser">
                        Tambah Peserta
                    </button>
                    <label class="text-primary">tambah peserta yang belum terdaftar</label>
                </div>
                <?= $this->session->flashdata('message'); ?>
                <form action="<?= base_url('ImportController/add_peserta_to_ujian'); ?>" method="POST">
                    <input name="id" value="<?= $id ?>" type="hidden" />
                    <table class="table text-center" id="score">
                        <thead>
                            <tr>
                               <th>No</th>
                                <th>Nama</th>
                                <th>Username</th>
                                <th>No Handphone</th>
                                <th>Asal</th>
                                <th>Aksi
                                    <input type="checkbox" value="" id="checked-all">
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            $no = 1;
                            $j = 0;
                            $this->db->reconnect();
                            $result = $this->db->query("call get_not_peserta_ujian_list_by_sesi('$id')");
                            $jumlah = count($result->result_array());
                            $id_p = array();
                            for ($k = 0; $k < $jumlah; $k++) {
                                $id_p[$k] = " ";
                            }
                            $i = 0;
                            foreach ($peserta_id as $value) {
                                $id_p[$i] = $value['peserta_id'];
                                $i++;
                            }
                            foreach ($result->result_array() as $row) { ?>
                                <tr>
                                    <td><?= $no ?></td>
                                    <td><?= $row['nama'] ?></td>
                                    <td><?= $row['username'] ?></td>
                                    <td><?= $row['no_hp'] ?></td>
                                    <td><?php echo $row['asal_sekolah']; ?></td>
                                    <td>
                                        <?php
                                        $check = 0;
                                        foreach ($id_p as $value1) {
                                            if ($row['id'] == $value1) {
                                                $check = 1;
                                                break;
                                            }
                                        }
                                        // if ($check == 1) {
                                        ?>

                                        <input class="form-check-input" id="pilih" type="checkbox" value="<?= $row['id'] ?>" name="pilih[]">
                                    </td>
                                </tr>
                            <?php $no++;
                                $j++;
                            } ?>
                        </tbody>
                    </table>
                    <div class="modal-footer">
                        <a type="button" class="btn btn-secondary" data-dismiss="modal" href="<?= base_url('admin/jadwal') ?>">Batal</a>
                        <button type="submit" class="btn btn-primary">Simpan</button>
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
    $('#checked-all-soal').on('change', function(e) {
        e.preventDefault()
        $('input[id=pilihSoal]').prop('checked', this.checked)
    });
</script>
