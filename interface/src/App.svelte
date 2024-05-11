<script lang="ts">
  let showUI : boolean = false;
  let RescoureName : string;

const onEvent = async(event: MessageEvent) => {
    showUI = await event.data.action;
    RescoureName = await event.data.resource;
};


const CloseUI = () => {
    showUI = false;
    fetch(`https://${RescoureName}/CloseUI`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        itemId: 'my-item'
    })
}).then(resp => resp.json()).then(resp => console.log(resp));
};


</script>
<main>
  {#if showUI}
      <div class="container">
        <div class="Render">
            <div class="select-color">
              
            </div>
            <div class="main">

            </div>
            <button class="payment">
                <span id='text-payment'>ชำระเงิน</span>
            </button>
            <button class="exit" on:click={CloseUI}>
              <span id='text-exit'>ออก</span>
            </button>
        </div>
      </div>
  {/if}
</main>

<style>

</style>

<svelte:window on:message={onEvent} />
