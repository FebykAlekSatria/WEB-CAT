<!-- Content Wrapper -->
<!--modal ada peserta sesi -->
<div class="modal fade" id="addListUserSesi" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Tambah Peserta Sesi</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="<?= base_url('ImportController/excel_peserta_to_sesi'); ?>" method="POST" enctype="multipart/form-data">
                    <div class="form-group">
                        <label>PIN Sesi</label>
                        <input type="text" class="form-control" name="PIN" id="PIN" placeholder="masukkan PIN sesi">
                    </div>
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
<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-4 text-gray-800 text-bold">Jadwal Ujian</h1>
    <?= $this->session->flashdata('message'); ?>
    <div class="card border-left-primary shadow mb-4">
        <div class="card-header py-2">
            <a type="button" class="fas fa-plus-square fa-2x text-primary mx-1" href="<?= base_url('admin/tambahsesi') ?>"></a>
            <i type="button" class="fas fa-file-upload fa-2x text-success mx-1" data-toggle="modal" data-target="#addListUserSesi"></i>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-sm table-bordered table-striped text-center" id="score" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>PIN Sesi</th>
                            <th>Nama Ujian</th>
                            <th>Tempat</th>
                            <!-- <th>Tanggal</th> -->
                            <th>Waktu Mulai</th>
                            <th>Waktu Selesai</th>
                            <th class="col-2">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $no = 1;
                        $result = $this->db->query('SELECT * FROM view_sesi_list');
                        foreach ($result->result_array() as $row) {
                            // $arr1 = explode(' ', $row['waktu_mulai']);
                        ?>
                            <tr>
                                <td><?= $no ?></td>
                                <td><?= $row['kode_sesi'] ?></td>
                                <td class="bg-primary"><a class="text-white" style="text-decoration:none" href="<?= base_url('admin/pesertasesi') ?>?id=<?= $row['id'] ?>"><?= $row['nama_ujian'] ?></a></td>
                                <td><?= $row['tempat_ujian'] ?></td>
                                <td><?= $row['waktu_mulai'] ?></td>
                                <td><?= $row['waktu_selesai'] ?></td>
                                <td>
                                    <a type="button" class="fas fa-pen-square fa-lg text-success" href="<?= base_url('admin/editsesi') ?>?id=<?= $row['id'] ?>"></a>
                                    <a type="button" class="fas fa-user-plus fa-lg text-primary" href="<?= base_url('admin/tambahpesertasesi') ?>?id=<?= $row['id'] ?>"></a>
                                    <a type="button" class="fas fa-clipboard-list fa-lg text-info" href="<?= base_url('admin/tambahsoalsesi') ?>?id=<?= $row['id'] ?>"></a>
                                    <a type="button" class="fas fa-trash fa-lg text-danger" href="<?= base_url('ImportController/delete_sesi') ?>?id=<?= $row['id'] ?>"></a>
                                </td>
                            </tr>
                        <?php
                            $no++;
                            $arr1 = null;
                        } ?>
                    </tbody>
                </table>
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
