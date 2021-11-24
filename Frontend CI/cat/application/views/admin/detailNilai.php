<!-- Content Wrapper -->

<!-- Begin Page Content -->
<?php
$no_p = $this->input->get('no_p');

?>
<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-4 text-gray-800 text-bold">Detail nilai</h1>
    <div class="card border-left-primary shadow mb-4">
        <div class="card-header py-2">
        </div>
        <div class="card-body">
            <div class="table-responsive table-wrapper-scroll-y my-custom-scrollbar">
                <table class="table table-bordered table-striped text-center" id="score" cellspacing="0">
                    <thead>
                        <tr>
                            <th class="col-1">No</th>
                            <th>Nama Kategori</th>
                            <th>Nilai</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $no = 1;
                        $result = $this->db->query("call get_nilai_list_by_no_peserta('$no_p')");
                        foreach ($result->result_array() as $row) {
                        ?>
                        <tr>
                            <td><?= $no ?></td>
                            <td><?= $row['nama_kategori'] ?></td>
                            <td><?= $row['total_nilai_kategori'] ?></td>
                        </tr>
                        <?php
                         $no++;
                         }
                        ?>
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
