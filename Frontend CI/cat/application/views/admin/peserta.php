<!-- Content Wrapper -->
<!-- Begin Page Content -->
<!-- add peserta modal -->
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
                <form class="addPeserta" method="POST" action="<?= base_url('ImportController/add_peserta'); ?>">
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

<!-- add daftar peserta modal -->
<div class="modal fade" id="addListUser" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Tambah Peserta</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="<?= base_url('ImportController/excel_peserta'); ?>" method="POST" enctype="multipart/form-data">
                    <div class="form-group">
                        <label>Pilih File Excel</label>
                        <input type="file" class="form-control" name="fileExcel" accept=".xls, .xlsx" required>
                    </div>
                    <div>
                        <button class='btn btn-primary' type="submit">
                            <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                            Import
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>



<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-4 text-gray-800 text-bold">Peserta</h1>
    <?= $this->session->flashdata('message'); ?>
    <div class="card border-left-primary shadow mb-4">
        <div class="card-header py-2">
            <i type="button" class="fas fa-plus-square fa-2x text-primary mx-1" data-toggle="modal" data-target="#addUser"></i>
            <i type="button" class="fas fa-file-upload fa-2x text-success mx-1" data-toggle="modal" data-target="#addListUser"></i>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-sm table-bordered table-striped text-center" id="score" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th class="col-1">No</th>
                            <th>Nama Lengkap</th>
                            <th>Asal Sekolah</th>
                            <th>No Handphone</th>
                            <th class="col-1">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $no = 1;
                        $result = $this->db->query('select * from view_peserta_list');
                        foreach ($result->result_array() as $row) { ?>
                            <tr>
                                <td><?php echo $no; ?></td>
                                <td><?php echo $row['nama']; ?></td>
                                <td><?php echo $row['asal_sekolah']; ?></td>
                                <td><?php echo $row['no_hp']; ?></td>
                                <td>
                                    <!--                              onclick="return false;" -->
                                    <i type="button" class="fas fa-pen-square fa-lg text-success" data-toggle="modal" data-target="#editUser<?= $row['peserta_id']; ?>"></i>
                                    <a href="<?= base_url('ImportController/delete_peserta') ?>?id=<?= $row['peserta_id'] ?>"><i class="fas fa-trash fa-lg text-danger"></i></a>
                                </td>
                            </tr>
                        <?php $no++;
                        } ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- card soal -->

</div>
<!-- /.container-fluid -->
</div>
<!-- End of Main Content -->
<footer class="sticky-footer bg-white">
    <div class="container my-auto">
        <div class="copyright text-center my-auto">
            <span>Copyright &copy;Website 2021</span>
        </div>
    </div>
</footer>


</div>
<!-- End of Content Wrapper -->

</div>
<!-- End of Page Wrapper -->

<!-- Scroll to Top Button-->
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>

<!-- modal edit-->
<?php
foreach ($result->result_array() as $row) { ?>
    <div class="modal fade" id="editUser<?= $row['peserta_id']; ?>" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <?php
        $no = 0;
        $id = $row['peserta_id'];
        $this->db->reconnect();
        $result1 = $this->db->query("call get_detail_peserta('$id')");
        foreach ($result1->result_array() as $row1) : $no++; ?>
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLongTitle">Edit Peserta</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form class="edit" action="<?= base_url('ImportController/edit_peserta'); ?>" method="POST">
                            <div class=" form-group">
                                <label>Nama Lengkap</label>
                                <input name="id" value="<?= $row['peserta_id'] ?>" type="hidden" />
                                <input type="text" class="form-control" id="fullName" name="fullName" placeholder="nama lengkap peserta" value="<?php echo $row1['nama']; ?>">
                            </div>
                            <div class=" form-group">
                                <label>Username</label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="username peserta" value="<?php echo $row1['username']; ?>" disabled>
                            </div>
                            <div class="form-group">
                                <label>No Handphone</label>
                                <input type="number" class="form-control" id="noHandphone" name="noHandphone" placeholder="no hanphone" value="<?php echo $row1['no_hp']; ?>">
                            </div>
                            <div class="form-group">
                                <label>Asal Sekolah</label>
                                <input type="text" class="form-control" id="asal" name="asal" placeholder="asal sekolah" value="<?php echo $row1['asal_sekolah']; ?>">
                            </div>
                            <div class="form-group">
                                <label>password</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="masukkan password" value="">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">batal</button>
                                <button type="submit" class="btn btn-primary">Simpan</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    </div>
<?php } ?>
<!-- akhir modal edit-->
