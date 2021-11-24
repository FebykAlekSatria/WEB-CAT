<!-- Content Wrapper -->

<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-4 text-gray-800 text-bold">Jadwal Ujian</h1>
    <div class="card border-left-primary shadow mb-4">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-sm table-bordered table-striped text-center" id="score" width="100%" cellspacing="0">
                   <thead>
                        <tr>
                            <th>No</th>
                            <th>No Peserta</th>
                            <th>Nama</th>
                            <th>Username</th>
                            <th>No Handphone</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $id = $this->input->get('id');
                        $result = $this->db->query("call get_peserta_ujian_list_by_sesi('$id')");
                        $no = 1;
                        if (!empty($result)) {
                            foreach ($result->result_array() as $row) {
                        ?>
                                <tr>
                                    <td><?= $no ?></td>
                                    <td><?= $row['no_peserta'] ?></td>
                                    <td><?= $row['nama'] ?></td>
                                    <td><?= $row['username'] ?></td>
                                    <td><?= $row['no_hp'] ?></td>
                                    <td>
                                        <a type="button" class="fas fa-trash fa-lg text-danger" href="<?= base_url('ImportController/delete_peserta_sesi') ?>?id=<?= $row['no_peserta'] ?>"></a>
                                    </td>
                                </tr>
                        <?php
                                $no++;
                            }
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
