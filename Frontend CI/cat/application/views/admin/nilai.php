<!-- Content Wrapper -->

<!-- Begin Page Content -->

<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-4 text-gray-800 text-bold">Daftar Nilai Peserta Ujian</h1>
    <div class="card border-left-primary shadow mb-4">
        <div class="card-header py-2">
            <form action="<?= base_url('admin/nilai'); ?>" method="POST">
                <select class="custom-select col-2" id="idKategori" name="idKategori">
                    <option selected>Pilih Ujian</option>
                    <?php $result = $this->db->query('call get_sesi_list()');
                    foreach ($result->result_array() as $row) {
                    ?>
                        <option id=" idKategori" name="idKatgori" value="<?= $row['id'] ?>"><?= $row['nama_ujian'] ?></option>
                    <?php } ?>
                </select>
                <button class="btn btn-primary" type="submit">Pilih</button>
            </form>
        </div>
        <div class="card-body">
            <div class="table-responsive table-wrapper-scroll-y my-custom-scrollbar">
                <?php
                if (!empty($id)) {
                ?>
                    <table class="table table-bordered table-striped text-center" id="score" cellspacing="0">
                        <thead>
                            <tr>
                                <th class="col-1">No</th>
                                <th>No Peserta</th>
                                <th>Nama</th>
                                <th>No Handphone</th>
                                <th>Total Nilai</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            $no = 1;
                            $this->db->reconnect();
                            $result = $this->db->query("call get_total_nilai_list('$id')");
                            foreach ($result->result_array() as $row) {
                            ?>
                                <tr>
                                    <td><?= $no ?></td>
                                    <td><?= $row['no_peserta'] ?></td>
                                    <td><?= $row['nama'] ?></td>
                                    <td><?= $row['no_hp'] ?></td>
                                    <td>
                                        <a href="<?= base_url('admin/detailnilai') ?>?no_p=<?= $row['no_peserta'] ?>">
                                            <?= $row['total_nilai'] ?>
                                        </a>
                                    </td>
                                </tr>
                            <?php
                                $no++;
                            }; ?>
                        </tbody>
                    </table>
                <?php
                }; ?>
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
