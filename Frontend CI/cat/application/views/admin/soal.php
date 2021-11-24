<!-- Content Wrapper -->

<!-- Begin Page Content -->
<!-- modal add list soal excel-->
<div class="modal fade" id="addListSoal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Tambah Soal</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="<?= base_url('ImportController/excel_soal'); ?>" method="POST" enctype="multipart/form-data">
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

<!-- modal add kategori-->
<div class="modal fade" id="addKategori" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Tambah Kategori</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form method="POST" enctype="multipart/form-data" action="<?= base_url('ImportController/add_kategori'); ?>">
                    <div class="form-group">
                        <label>Nama Kategori</label>
                        <input class="form-control" type="text" name="name" placeholder="masukkan nama kategori" />
                    </div>
                    <div class="form-group">
                        <label>Nilai Kategori</label>
                        <input class="form-control" type="number" name="nilai" placeholder="masukkan nilai kategori" />
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


<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-4 text-gray-800 text-bold">Kategori dan Soal</h1>
    <?= $this->session->flashdata('message'); ?>
    <div class="card shadow border-left-primary mb-4">
        <div class="card-header py-2">
            <div class="row">
                <a class="fas fa-clipboard-list fa-2x mx-1 text-primary" style="text-decoration:none" href="<?= base_url("admin/tambahsoal") ?>"></a>
                <a class="fas fa-file-upload fa-2x text-success mx-1" data-toggle="modal" data-target="#addListSoal"></a>
                <button type="button" class="btn btn-primary btn-sm ml-auto mx-2" data-toggle="modal" data-target="#addKategori">Tambah Kategori</button>
                <a href="<?= base_url("admin/kategori") ?>">
                    <button type="button" class="btn btn-success btn-sm">Daftar Kategori</button>
                </a>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-sm table-bordered table-striped text-center" id="score" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th class="col-1">No</th>
                            <th class="col-2">Kategori</th>
                            <th>Pertanyaan</th>
                            <th class="col-1">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $no = 1;
                        $result = $this->db->query('select * from view_soal_list');
                        foreach ($result->result_array() as $row) { ?>
                            <tr>
                                <td><?php echo $no; ?></td>
                                <td><?php echo $row['nama_kategori']; ?></td>
                                <td><?= htmlspecialchars_decode($row['pertanyaan']) ?></td>
                                <td>
                                    <a class="fas fa-pen-square fa-lg text-success" href="<?= base_url('admin/editsoal') ?>?id=<?= $row['id'] ?>"></a>
                                    <a class="fas fa-trash fa-lg text-danger" href="<?= base_url('ImportController/delete_soal') ?>?id=<?= $row['id'] ?>" id="<?= $row['id'] ?>"></a>
                                </td>
                            </tr>
                        <?php $no++;
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

<!-- Logout Modal-->
