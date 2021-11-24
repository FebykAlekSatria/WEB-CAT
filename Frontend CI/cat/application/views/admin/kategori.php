<!-- Content Wrapper -->
<!-- Begin Page Content -->

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
    <h1 class="h3 mb-4 text-gray-800 text-bold">Kategori</h1>
    <div class="card shadow border-left-primary mb-4">
        <div class="card-header py-2">
            <div class="row">
                <button type="button" class="btn btn-primary btn-sm ml-auto mx-2" data-toggle="modal" data-target="#addKategori">Tambah Kategori</button>
                <a href="<?= base_url("admin/soal") ?>">
                    <button type="button" class="btn btn-success btn-sm">Daftar Soal</button>
                </a>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-sm table-bordered table-striped text-center" id="score" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th class="col-1">No</th>
                            <th>Kategori</th>
                            <th>Nilai</th>
                            <th class="col-1">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $no = 1;
                        $result = $this->db->query('select * from view_kategori_list');
                        foreach ($result->result_array() as $row) { ?>
                            <tr>
                                <td><?php echo $no; ?></td>
                                <td><?php echo $row['nama_kategori']; ?></td>
                                <td><?php echo $row['nilai_kategori']; ?></td>
                                <td>
                                    <a class="fas fa-pen-square fa-lg text-success" data-toggle="modal" data-target="#editKategori<?= $row['id']; ?>"></a>
                                    <a href="<?= base_url('ImportController/delete_kategori') ?>?id=<?= $row['id'] ?>"><i class="fas fa-trash fa-lg text-danger"></i></a>
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

<!-- modal edit kategori-->
<?php
$no = 0;
foreach ($result->result_array() as $row) : $no++; ?>
    <div class="modal fade" id="editKategori<?= $row['id']; ?>" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Edit Kategori</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form method="POST" enctype="multipart/form-data" action="<?= base_url('ImportController/edit_kategori') ?>">
                        <div class="form-group">
                            <label>Nama Kategori</label>
                            <input class="form-control" type="text" name="name" placeholder="masukkan nama kategori" value="<?= $row['nama_kategori'] ?>" />
                        </div>
                        <div class="form-group">
                            <label>Nilai Kategori</label>
                            <input class="form-control" type="number" name="nilai" placeholder="masukkan nilai kategori" value="<?= $row['nilai_kategori'] ?>" />
                        </div>
                        <div class="form-group">
                            <input class="form-control" type="hidden" name="id" value="<?= $row['id'] ?>" />
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
<?php endforeach; ?>
